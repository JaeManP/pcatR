#' Default pCAT plotting palette
#'
#' @return A named character vector of color values.
#' @rdname plot_pcat_profile
#' @export
pcat_palette <- function() {
  c(
    strong_barrier = "#8C2D2D",
    weak_barrier = "#D98C8C",
    neutral = "#BDBDBD",
    weak_facilitator = "#88C999",
    strong_facilitator = "#246B3C",
    missing = "#ECECEC"
  )
}

.pcat_pretty_value <- function(x) {
  x <- as.character(x)
  missing <- is.na(x) | !nzchar(trimws(x))
  x[missing] <- "(missing)"
  x <- gsub("_", " ", x, fixed = TRUE)
  x <- gsub("[[:space:]]+", " ", x)
  x[tolower(x) == "mid implementation"] <- "Mid-implementation"
  x[tolower(x) == "planning"] <- "Planning"
  x
}

.pcat_plot_group_label <- function(
    data,
    group_vars,
    include_names = FALSE) {
  if (length(group_vars) == 0L) {
    return(rep("Overall", nrow(data)))
  }
  pieces <- lapply(group_vars, function(column) {
    value <- .pcat_pretty_value(data[[column]])
    if (isTRUE(include_names)) {
      name <- gsub("_", " ", column, fixed = TRUE)
      paste0(name, ": ", value)
    } else {
      value
    }
  })
  do.call(paste, c(pieces, sep = " | "))
}

.pcat_item_labels <- function(items, label, label_width) {
  if (identical(label, "item_id")) {
    return(paste0("Item ", items$item_id))
  }
  paste0(
    "Item ", items$item_id, ". ",
    .pcat_wrap(items[[label]], width = label_width)
  )
}

#' Plot an item-level barrier-facilitator profile
#'
#' Creates a publication-quality diverging bar chart. Barriers are plotted to
#' the left, facilitators to the right, and the neutral share is printed at the
#' center. Percentages use complete five-category responses as the denominator.
#'
#' @param data Raw, validated, or classified pCAT data.
#' @param group_vars Optional grouping columns used for facets.
#' @param label Item label field.
#' @param label_width Approximate character width used to wrap item labels.
#' @param facet_ncol Number of facet columns. The default uses one or two
#'   columns depending on the number of groups.
#' @param facet_label Whether facet strips show values only or names and values.
#' @param show_neutral Print the neutral percentage at the center.
#' @param show_n Include the complete-response denominator in the neutral label.
#' @param base_size Base text size passed to the plot theme.
#' @param label_size Text size for item labels.
#' @param legend_position Position of the shared legend.
#' @param title,subtitle,caption Optional plot annotations.
#' @param palette Named color vector. See [pcat_palette()].
#' @return A `ggplot` object.
#' @export
plot_pcat_profile <- function(
    data,
    group_vars = NULL,
    label = c(
      "cfir_original_construct", "cfir_2022_construct", "item_text", "item_id"
    ),
    label_width = 42L,
    facet_ncol = NULL,
    facet_label = c("values", "names_values"),
    show_neutral = TRUE,
    show_n = TRUE,
    base_size = 11,
    label_size = 8.5,
    legend_position = "bottom",
    title = "pCAT barrier-facilitator profile",
    subtitle = NULL,
    caption = NULL,
    palette = pcat_palette()) {
  label <- match.arg(label)
  facet_label <- match.arg(facet_label)
  classified <- .pcat_as_classified(data, attach_items = TRUE)
  group_vars <- unique(as.character(group_vars %||% character()))
  .pcat_check_columns(classified, group_vars)

  required_colors <- c(
    "strong_barrier", "weak_barrier", "neutral",
    "weak_facilitator", "strong_facilitator"
  )
  if (!all(required_colors %in% names(palette))) {
    .pcat_abort(
      "`palette` must contain colors named strong_barrier, weak_barrier, neutral, weak_facilitator, and strong_facilitator."
    )
  }

  eligible <- if ("pcat_record_eligible" %in% names(classified)) {
    classified$pcat_record_eligible %in% TRUE
  } else {
    rep(TRUE, nrow(classified))
  }
  complete <- classified[
    eligible & !is.na(classified$pcat_class5) &
      !is.na(classified$item_id) & classified$item_id %in% 1:14,
    ,
    drop = FALSE
  ]
  if (nrow(complete) == 0L) {
    .pcat_abort("No complete five-category responses are available to plot.")
  }

  complete$.pcat_group <- .pcat_plot_group_label(
    complete,
    group_vars,
    include_names = identical(facet_label, "names_values")
  )
  group_levels <- unique(complete$.pcat_group)
  complete$.pcat_group <- factor(complete$.pcat_group, levels = group_levels)
  complete$pcat_class5 <- as.character(complete$pcat_class5)

  counts <- stats::aggregate(
    rep(1L, nrow(complete)),
    by = list(
      .pcat_group = as.character(complete$.pcat_group),
      item_id = complete$item_id,
      pcat_class5 = complete$pcat_class5
    ),
    FUN = sum
  )
  names(counts)[names(counts) == "x"] <- "n"

  denominators <- stats::aggregate(
    rep(1L, nrow(complete)),
    by = list(
      .pcat_group = as.character(complete$.pcat_group),
      item_id = complete$item_id
    ),
    FUN = sum
  )
  names(denominators)[names(denominators) == "x"] <- "n_complete_class"

  class_levels <- c(
    "strong_barrier", "weak_barrier", "neutral",
    "weak_facilitator", "strong_facilitator"
  )
  grid <- expand.grid(
    .pcat_group = group_levels,
    item_id = 1:14,
    pcat_class5 = class_levels,
    stringsAsFactors = FALSE
  )
  plot_data <- merge(
    grid,
    counts,
    by = c(".pcat_group", "item_id", "pcat_class5"),
    all.x = TRUE,
    sort = FALSE
  )
  plot_data$n[is.na(plot_data$n)] <- 0L
  plot_data <- merge(
    plot_data,
    denominators,
    by = c(".pcat_group", "item_id"),
    all.x = TRUE,
    sort = FALSE
  )
  plot_data$prop <- .pcat_divide(plot_data$n, plot_data$n_complete_class)

  items <- pcat_items("both")
  items$item_label <- .pcat_item_labels(items, label, label_width)
  plot_data$item_label <- items$item_label[match(plot_data$item_id, items$item_id)]
  plot_data$item_label <- factor(
    plot_data$item_label,
    levels = rev(items$item_label)
  )
  plot_data$.pcat_group <- factor(plot_data$.pcat_group, levels = group_levels)

  neutral <- plot_data[plot_data$pcat_class5 == "neutral", , drop = FALSE]
  neutral$neutral_label <- ifelse(
    is.na(neutral$n_complete_class) | neutral$n_complete_class == 0L,
    "No complete responses",
    if (isTRUE(show_n)) {
      paste0(
        "Neutral ", round(100 * neutral$prop), "%\n(n=",
        neutral$n_complete_class, ")"
      )
    } else {
      paste0("Neutral ", round(100 * neutral$prop), "%")
    }
  )

  bars <- plot_data[plot_data$pcat_class5 != "neutral", , drop = FALSE]
  bars$value <- ifelse(
    bars$pcat_class5 %in% c("strong_barrier", "weak_barrier"),
    -bars$prop,
    bars$prop
  )
  bars$pcat_class5 <- factor(
    bars$pcat_class5,
    levels = c(
      "strong_barrier", "weak_barrier",
      "weak_facilitator", "strong_facilitator"
    )
  )

  if (is.null(caption)) {
    caption <- paste(
      "Denominator: complete five-category responses for each item.",
      "The -2 to +2 display convention is not used as a total scale score."
    )
  }

  p <- ggplot2::ggplot(
    bars,
    ggplot2::aes(x = value, y = item_label, fill = pcat_class5)
  ) +
    ggplot2::geom_col(width = 0.72, na.rm = TRUE) +
    ggplot2::geom_vline(xintercept = 0, linewidth = 0.35, color = "grey35") +
    ggplot2::scale_x_continuous(
      limits = c(-1.05, 1.05),
      breaks = seq(-1, 1, by = 0.25),
      labels = function(x) paste0(round(abs(x) * 100), "%"),
      expand = ggplot2::expansion(mult = c(0, 0))
    ) +
    ggplot2::scale_fill_manual(
      values = palette[c(
        "strong_barrier", "weak_barrier",
        "weak_facilitator", "strong_facilitator"
      )],
      breaks = c(
        "strong_barrier", "weak_barrier",
        "weak_facilitator", "strong_facilitator"
      ),
      labels = c(
        strong_barrier = "Strong barrier",
        weak_barrier = "Weak barrier",
        weak_facilitator = "Weak facilitator",
        strong_facilitator = "Strong facilitator"
      ),
      drop = FALSE,
      name = NULL
    ) +
    ggplot2::labs(
      x = "Share of complete responses",
      y = NULL,
      title = title,
      subtitle = subtitle,
      caption = caption
    ) +
    ggplot2::guides(
      fill = ggplot2::guide_legend(nrow = 1, byrow = TRUE)
    ) +
    ggplot2::coord_cartesian(clip = "off") +
    ggplot2::theme_minimal(base_size = base_size) +
    ggplot2::theme(
      panel.grid.major.y = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank(),
      axis.text.y = ggplot2::element_text(
        size = label_size,
        lineheight = 0.95,
        color = "black"
      ),
      axis.text.x = ggplot2::element_text(color = "black"),
      axis.title.x = ggplot2::element_text(margin = ggplot2::margin(t = 8)),
      strip.text = ggplot2::element_text(face = "bold", size = base_size),
      strip.background = ggplot2::element_rect(
        fill = "grey95",
        color = "grey80",
        linewidth = 0.4
      ),
      panel.spacing = grid::unit(1.2, "lines"),
      legend.position = legend_position,
      legend.box = "horizontal",
      plot.title.position = "plot",
      plot.caption = ggplot2::element_text(hjust = 0, size = base_size - 2)
    )

  if (isTRUE(show_neutral)) {
    p <- p + ggplot2::geom_label(
      data = neutral,
      ggplot2::aes(x = 0, y = item_label, label = neutral_label),
      inherit.aes = FALSE,
      size = max(2.5, label_size / 3.0),
      lineheight = 0.9,
      color = "grey20",
      fill = "white",
      label.padding = grid::unit(0.08, "lines"),
      label.r = grid::unit(0.08, "lines")
    )
  }

  if (length(group_vars) > 0L) {
    if (is.null(facet_ncol)) {
      facet_ncol <- if (length(group_levels) <= 2L) {
        length(group_levels)
      } else {
        2L
      }
    }
    facet_ncol <- suppressWarnings(as.integer(facet_ncol))
    if (length(facet_ncol) != 1L || is.na(facet_ncol) || facet_ncol < 1L) {
      .pcat_abort("`facet_ncol` must be a positive integer or NULL.")
    }
    p <- p + ggplot2::facet_wrap(
      ggplot2::vars(.pcat_group),
      ncol = facet_ncol
    )
  }

  p
}

#' Plot a respondent-by-item pCAT heatmap
#'
#' @param data Raw, validated, or classified pCAT data.
#' @param respondent_id Respondent identifier column.
#' @param facet_vars Optional grouping columns used for facets.
#' @param facet_ncol Number of facet columns.
#' @param facet_label Whether facet strips show values only or names and values.
#' @param base_size Base text size.
#' @param title,subtitle,caption Optional plot annotations.
#' @param palette Named color vector. See [pcat_palette()].
#' @return A `ggplot` object.
#' @rdname plot_pcat_profile
#' @export
plot_pcat_heatmap <- function(
    data,
    respondent_id = "respondent_id",
    facet_vars = NULL,
    facet_ncol = NULL,
    facet_label = c("values", "names_values"),
    base_size = 11,
    title = "pCAT respondent-by-item profile",
    subtitle = NULL,
    caption = paste(
      "Missing, invalid, effect-incomplete, or absent item records are",
      "shown in light grey."
    ),
    palette = pcat_palette()) {
  facet_label <- match.arg(facet_label)
  classified <- .pcat_as_classified(data, attach_items = TRUE)
  facet_vars <- unique(as.character(facet_vars %||% character()))
  .pcat_check_columns(classified, c(respondent_id, facet_vars, "item_id"))

  if ("pcat_record_eligible" %in% names(classified)) {
    classified <- classified[classified$pcat_record_eligible %in% TRUE, , drop = FALSE]
  }
  classified <- classified[
    !is.na(classified$item_id) & classified$item_id %in% 1:14,
    ,
    drop = FALSE
  ]
  if (nrow(classified) == 0L) {
    .pcat_abort("No eligible pCAT response records are available to plot.")
  }

  classified$.pcat_group <- .pcat_plot_group_label(
    classified,
    facet_vars,
    include_names = identical(facet_label, "names_values")
  )
  classified$.pcat_respondent_raw <- as.character(classified[[respondent_id]])
  group_levels <- unique(classified$.pcat_group)
  respondent_levels <- unique(classified$.pcat_respondent_raw)

  tile_key <- .pcat_key(
    classified,
    c(".pcat_group", ".pcat_respondent_raw", "item_id")
  )
  if (any(duplicated(tile_key))) {
    .pcat_abort(
      paste(
        "The requested heatmap has more than one record for a",
        "group-respondent-item cell. Add assessment columns to `facet_vars`",
        "or resolve duplicate records before plotting."
      ),
      "pcat_ambiguous_plot_cells"
    )
  }

  pair_key <- .pcat_key(
    classified,
    c(".pcat_group", ".pcat_respondent_raw")
  )
  pairs <- classified[
    !duplicated(pair_key),
    c(".pcat_group", ".pcat_respondent_raw"),
    drop = FALSE
  ]
  grid_parts <- lapply(seq_len(nrow(pairs)), function(i) {
    data.frame(
      .pcat_group = rep(pairs$.pcat_group[[i]], 14L),
      .pcat_respondent_raw = rep(pairs$.pcat_respondent_raw[[i]], 14L),
      item_id = 1:14,
      stringsAsFactors = FALSE,
      check.names = FALSE
    )
  })
  plot_data <- .pcat_bind_rows(grid_parts)
  values <- classified[
    c(".pcat_group", ".pcat_respondent_raw", "item_id", "pcat_class5")
  ]
  plot_data <- merge(
    plot_data,
    values,
    by = c(".pcat_group", ".pcat_respondent_raw", "item_id"),
    all.x = TRUE,
    sort = FALSE
  )

  plot_data$.pcat_group <- factor(plot_data$.pcat_group, levels = group_levels)
  plot_data$.pcat_respondent <- factor(
    plot_data$.pcat_respondent_raw,
    levels = rev(respondent_levels)
  )
  plot_data$.pcat_item <- factor(
    plot_data$item_id,
    levels = 1:14,
    labels = paste0("Item ", 1:14)
  )

  class_values <- as.character(plot_data$pcat_class5)
  class_values[is.na(class_values)] <- "missing_or_incomplete"
  class_levels <- c(
    "strong_barrier", "weak_barrier", "neutral",
    "weak_facilitator", "strong_facilitator", "missing_or_incomplete"
  )
  plot_data$.pcat_plot_class <- factor(class_values, levels = class_levels)

  fill_values <- c(
    palette[c(
      "strong_barrier", "weak_barrier", "neutral",
      "weak_facilitator", "strong_facilitator"
    )],
    missing_or_incomplete = unname(palette["missing"])
  )
  fill_labels <- c(
    strong_barrier = "Strong barrier",
    weak_barrier = "Weak barrier",
    neutral = "Neutral",
    weak_facilitator = "Weak facilitator",
    strong_facilitator = "Strong facilitator",
    missing_or_incomplete = "Missing/incomplete"
  )

  p <- ggplot2::ggplot(
    plot_data,
    ggplot2::aes(x = .pcat_item, y = .pcat_respondent, fill = .pcat_plot_class)
  ) +
    ggplot2::geom_tile(color = "white", linewidth = 0.25) +
    ggplot2::scale_fill_manual(
      values = fill_values,
      breaks = class_levels,
      labels = fill_labels,
      drop = FALSE,
      name = NULL
    ) +
    ggplot2::scale_x_discrete(drop = FALSE) +
    ggplot2::labs(
      x = "pCAT item",
      y = "Respondent",
      title = title,
      subtitle = subtitle,
      caption = caption
    ) +
    ggplot2::guides(fill = ggplot2::guide_legend(nrow = 2, byrow = TRUE)) +
    ggplot2::theme_minimal(base_size = base_size) +
    ggplot2::theme(
      panel.grid = ggplot2::element_blank(),
      axis.text.x = ggplot2::element_text(angle = 45, hjust = 1, color = "black"),
      axis.text.y = ggplot2::element_text(color = "black"),
      strip.text = ggplot2::element_text(face = "bold"),
      strip.background = ggplot2::element_rect(
        fill = "grey95",
        color = "grey80",
        linewidth = 0.4
      ),
      legend.position = "bottom",
      plot.title.position = "plot",
      plot.caption = ggplot2::element_text(hjust = 0)
    )

  if (length(facet_vars) > 0L) {
    if (is.null(facet_ncol)) {
      facet_ncol <- if (length(group_levels) <= 2L) length(group_levels) else 2L
    }
    facet_ncol <- suppressWarnings(as.integer(facet_ncol))
    if (length(facet_ncol) != 1L || is.na(facet_ncol) || facet_ncol < 1L) {
      .pcat_abort("`facet_ncol` must be a positive integer or NULL.")
    }
    p <- p + ggplot2::facet_wrap(
      ggplot2::vars(.pcat_group),
      ncol = facet_ncol,
      scales = "free_y"
    )
  }

  p
}

#' Plot paired pCAT change
#'
#' @param data Output from [pcat_change()] or classified data.
#' @param from,to Required only when `data` have not already been paired.
#' @param respondent_id Respondent identifier column in paired output.
#' @param facet_vars Optional grouping columns used for facets.
#' @param display Display transition categories or the descriptive delta code.
#' @param facet_ncol Number of facet columns.
#' @param facet_label Whether facet strips show values only or names and values.
#' @param base_size Base text size.
#' @param title,subtitle,caption Optional plot annotations.
#' @param ... Passed to [pcat_change()] when pairing is needed.
#' @return A `ggplot` object.
#' @rdname plot_pcat_profile
#' @export
plot_pcat_change <- function(
    data,
    from = NULL,
    to = NULL,
    respondent_id = "respondent_id",
    facet_vars = NULL,
    display = c("transition", "delta"),
    facet_ncol = NULL,
    facet_label = c("values", "names_values"),
    base_size = 11,
    title = "Paired pCAT change",
    subtitle = NULL,
    caption = NULL,
    ...) {
  display <- match.arg(display)
  facet_label <- match.arg(facet_label)
  change <- if (inherits(data, "pcat_change") ||
                "delta_display_code" %in% names(data)) {
    as.data.frame(data, stringsAsFactors = FALSE, check.names = FALSE)
  } else {
    if (is.null(from) || is.null(to)) {
      .pcat_abort("Supply `from` and `to` when `data` is not a pcat_change object.")
    }
    pcat_change(data, from = from, to = to, ...)
  }

  facet_vars <- unique(as.character(facet_vars %||% character()))
  .pcat_check_columns(change, c(respondent_id, facet_vars, "item_id"))
  if (nrow(change) == 0L) {
    .pcat_abort("No paired pCAT change records are available to plot.")
  }

  change$.pcat_group <- .pcat_plot_group_label(
    change,
    facet_vars,
    include_names = identical(facet_label, "names_values")
  )
  group_levels <- unique(change$.pcat_group)

  if (is.null(subtitle) && all(c("from_timepoint", "to_timepoint") %in% names(change))) {
    from_values <- unique(stats::na.omit(change$from_timepoint))
    to_values <- unique(stats::na.omit(change$to_timepoint))
    if (length(from_values) == 1L && length(to_values) == 1L) {
      subtitle <- paste0(from_values, " to ", to_values)
    }
  }

  change$.pcat_respondent_raw <- as.character(change[[respondent_id]])
  respondent_levels <- unique(change$.pcat_respondent_raw)
  tile_key <- .pcat_key(
    change,
    c(".pcat_group", ".pcat_respondent_raw", "item_id")
  )
  if (any(duplicated(tile_key))) {
    .pcat_abort(
      paste(
        "The requested change heatmap has more than one record for a",
        "group-respondent-item cell. Add identifying columns to `facet_vars`",
        "or correct the paired data before plotting."
      ),
      "pcat_ambiguous_plot_cells"
    )
  }

  pair_key <- .pcat_key(
    change,
    c(".pcat_group", ".pcat_respondent_raw")
  )
  pairs <- change[
    !duplicated(pair_key),
    c(".pcat_group", ".pcat_respondent_raw"),
    drop = FALSE
  ]
  grid_parts <- lapply(seq_len(nrow(pairs)), function(i) {
    data.frame(
      .pcat_group = rep(pairs$.pcat_group[[i]], 14L),
      .pcat_respondent_raw = rep(pairs$.pcat_respondent_raw[[i]], 14L),
      item_id = 1:14,
      stringsAsFactors = FALSE,
      check.names = FALSE
    )
  })
  plot_data <- .pcat_bind_rows(grid_parts)
  value_columns <- intersect(
    c(
      ".pcat_group", ".pcat_respondent_raw", "item_id",
      "transition", "delta_display_code"
    ),
    names(change)
  )
  values <- change[value_columns]
  plot_data <- merge(
    plot_data,
    values,
    by = c(".pcat_group", ".pcat_respondent_raw", "item_id"),
    all.x = TRUE,
    sort = FALSE
  )

  plot_data$.pcat_group <- factor(plot_data$.pcat_group, levels = group_levels)
  plot_data$.pcat_respondent <- factor(
    plot_data$.pcat_respondent_raw,
    levels = rev(respondent_levels)
  )
  plot_data$.pcat_item <- factor(
    plot_data$item_id,
    levels = 1:14,
    labels = paste0("Item ", 1:14)
  )

  if (identical(display, "transition")) {
    transition_levels <- c(
      "toward_barrier", "no_code_change", "toward_facilitation",
      "newly_observed", "followup_missing", "not_comparable"
    )
    transition_values <- as.character(plot_data$transition)
    transition_values[is.na(transition_values)] <- "not_comparable"
    plot_data$.pcat_plot_value <- factor(
      transition_values,
      levels = transition_levels
    )
    transition_colors <- c(
      toward_barrier = unname(pcat_palette()["strong_barrier"]),
      no_code_change = unname(pcat_palette()["neutral"]),
      toward_facilitation = unname(pcat_palette()["strong_facilitator"]),
      newly_observed = "#6B8EAD",
      followup_missing = "#D8B365",
      not_comparable = unname(pcat_palette()["missing"])
    )
    transition_labels <- c(
      toward_barrier = "Toward barrier",
      no_code_change = "No code change",
      toward_facilitation = "Toward facilitation",
      newly_observed = "Newly observed",
      followup_missing = "Follow-up missing",
      not_comparable = "Not comparable"
    )
    if (is.null(caption)) {
      caption <- paste(
        "Transitions describe movement between ordered response categories.",
        "They are not estimates of causal or interval-scale change."
      )
    }
    p <- ggplot2::ggplot(
      plot_data,
      ggplot2::aes(x = .pcat_item, y = .pcat_respondent, fill = .pcat_plot_value)
    ) +
      ggplot2::geom_tile(color = "white", linewidth = 0.25) +
      ggplot2::scale_fill_manual(
        values = transition_colors,
        breaks = transition_levels,
        labels = transition_labels,
        drop = FALSE,
        name = NULL
      ) +
      ggplot2::guides(fill = ggplot2::guide_legend(nrow = 2, byrow = TRUE))
  } else {
    if (is.null(caption)) {
      caption <- paste(
        "Positive descriptive codes indicate movement toward facilitation;",
        "negative codes indicate movement toward a barrier. Codes are not interval-scale effects."
      )
    }
    p <- ggplot2::ggplot(
      plot_data,
      ggplot2::aes(x = .pcat_item, y = .pcat_respondent, fill = delta_display_code)
    ) +
      ggplot2::geom_tile(color = "white", linewidth = 0.25) +
      ggplot2::scale_fill_gradient2(
        low = unname(pcat_palette()["strong_barrier"]),
        mid = "#F7F7F7",
        high = unname(pcat_palette()["strong_facilitator"]),
        midpoint = 0,
        limits = c(-4, 4),
        breaks = -4:4,
        na.value = unname(pcat_palette()["missing"]),
        name = "Descriptive\nchange code"
      )
  }

  p <- p +
    ggplot2::scale_x_discrete(drop = FALSE) +
    ggplot2::labs(
      x = "pCAT item",
      y = "Respondent",
      title = title,
      subtitle = subtitle,
      caption = caption
    ) +
    ggplot2::theme_minimal(base_size = base_size) +
    ggplot2::theme(
      panel.grid = ggplot2::element_blank(),
      axis.text.x = ggplot2::element_text(angle = 45, hjust = 1, color = "black"),
      axis.text.y = ggplot2::element_text(color = "black"),
      strip.text = ggplot2::element_text(face = "bold"),
      strip.background = ggplot2::element_rect(
        fill = "grey95",
        color = "grey80",
        linewidth = 0.4
      ),
      legend.position = "bottom",
      plot.title.position = "plot",
      plot.caption = ggplot2::element_text(hjust = 0)
    )

  if (length(facet_vars) > 0L) {
    if (is.null(facet_ncol)) {
      facet_ncol <- if (length(group_levels) <= 2L) length(group_levels) else 2L
    }
    facet_ncol <- suppressWarnings(as.integer(facet_ncol))
    if (length(facet_ncol) != 1L || is.na(facet_ncol) || facet_ncol < 1L) {
      .pcat_abort("`facet_ncol` must be a positive integer or NULL.")
    }
    p <- p + ggplot2::facet_wrap(
      ggplot2::vars(.pcat_group),
      ncol = facet_ncol,
      scales = "free_y"
    )
  }

  p
}

#' Save readable pCAT profiles as a multi-page PDF
#'
#' Each grouping combination is placed on its own page, which avoids clipped
#' labels and overcrowded multi-panel screen output.
#'
#' @param data Raw, validated, or classified pCAT data.
#' @param path Output PDF path.
#' @param group_vars Grouping columns defining one PDF page.
#' @param overwrite Overwrite an existing file.
#' @param width,height PDF page dimensions in inches.
#' @param title_prefix Prefix used in page titles.
#' @param ... Additional arguments passed to [plot_pcat_profile()].
#' @return The normalized output path, invisibly.
#' @rdname pcat_write_analysis
#' @export
pcat_save_profile_pdf <- function(
    data,
    path,
    group_vars = NULL,
    overwrite = FALSE,
    width = 11,
    height = 8.5,
    title_prefix = "pCAT profile",
    ...) {
  if (length(path) != 1L || is.na(path) || !nzchar(path)) {
    .pcat_abort("`path` must be one non-missing PDF file path.")
  }
  if (file.exists(path) && !isTRUE(overwrite)) {
    .pcat_abort(
      paste0("File already exists: `", path, "`. Set `overwrite = TRUE` to replace it.")
    )
  }
  width <- suppressWarnings(as.numeric(width))
  height <- suppressWarnings(as.numeric(height))
  if (length(width) != 1L || is.na(width) || width <= 0 ||
      length(height) != 1L || is.na(height) || height <= 0) {
    .pcat_abort("`width` and `height` must be positive numbers.")
  }

  classified <- .pcat_as_classified(data, attach_items = TRUE)
  group_vars <- unique(as.character(group_vars %||% character()))
  .pcat_check_columns(classified, group_vars)
  if (nrow(classified) == 0L) {
    .pcat_abort("No pCAT records are available to export.")
  }

  parent <- dirname(path)
  if (!dir.exists(parent)) {
    dir.create(parent, recursive = TRUE, showWarnings = FALSE)
  }

  if (length(group_vars) == 0L) {
    keys <- rep("Overall", nrow(classified))
    key_levels <- "Overall"
  } else {
    keys <- .pcat_key(classified, group_vars)
    key_levels <- unique(keys)
  }

  grDevices::pdf(path, width = width, height = height, onefile = TRUE)
  pdf_device <- grDevices::dev.cur()
  closed <- FALSE
  on.exit({
    if (!closed && !is.null(grDevices::dev.list()) &&
        pdf_device %in% grDevices::dev.list()) {
      grDevices::dev.off(which = pdf_device)
    }
  }, add = TRUE)

  for (key in key_levels) {
    one <- classified[keys == key, , drop = FALSE]
    page_label <- if (length(group_vars) == 0L) {
      "Overall"
    } else {
      .pcat_plot_group_label(one[1L, , drop = FALSE], group_vars)[[1L]]
    }
    page_title <- if (identical(page_label, "Overall")) {
      title_prefix
    } else {
      paste0(title_prefix, ": ", page_label)
    }
    p <- plot_pcat_profile(
      one,
      group_vars = NULL,
      title = page_title,
      ...
    )
    print(p)
  }

  grDevices::dev.off(which = pdf_device)
  closed <- TRUE
  invisible(normalizePath(path, winslash = "/", mustWork = TRUE))
}
