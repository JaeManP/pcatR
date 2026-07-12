# Project governance

`pcatR` is maintained as an independent open-source implementation.

## Decision classes

- **Routine maintenance:** documentation, tests, dependency updates, and bug
  fixes that preserve documented behavior may be merged after review.
- **Analytic behavior:** changes to validation, denominators, classification,
  consensus rules, or longitudinal logic require tests, changelog entries, and
  methodological documentation.
- **Source content:** changes to item wording, CFIR mappings, or strategy links
  require primary-source verification and attribution.
- **Scoring claims:** a total score or psychometric claim will not be introduced
  without published validation, a versioned specification, and explicit release
  review.

## Release policy

Releases require passing automated tests and `R CMD check`, reviewed source
manifests, synchronized version numbers, updated technical documentation, and a
signed Git tag when feasible.
