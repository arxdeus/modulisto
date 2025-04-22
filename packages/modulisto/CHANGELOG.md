# Changelog

---
## [3.0.0](https://github.com/arxdeus/modulisto/compare/modulisto-v2.4.0..3.0.0) - 2025-04-22

### Bug Fixes

- **(collections_store)** hide `value` under UnmodifiableView's - ([90a61e3](https://github.com/arxdeus/modulisto/commit/90a61e31617518e143ba41ba410f02df08e3a0b2))
- **(unit)** check unit state on `addListener`, `removeListener` - ([17f308f](https://github.com/arxdeus/modulisto/commit/17f308f152c0351cfe3d51a96e4139dfbd478c99))

### Features

- **(unit)** introduce `ModuleBindedUnitBase` with auto-disposition bind - ([1dec02a](https://github.com/arxdeus/modulisto/commit/1dec02a6b797fb1f77ba5cfae3479a8b98ebf16c))
-  [**BREAKING CHANGE**]operation - ([0bc2a72](https://github.com/arxdeus/modulisto/commit/0bc2a72837d0292e38375fc432c52503fe1c19f9))
-  [**BREAKING CHANGE**]mutation context - ([5359780](https://github.com/arxdeus/modulisto/commit/5359780898ecd0d5dc580a9ad4306322f98b5fe8))
- mutator accepts only `Store` and it subtypes - ([c58ac9b](https://github.com/arxdeus/modulisto/commit/c58ac9b17daa7ac8573df5ac99a95b8d18c28e55))
- `MapValueUnitView` maps new value lazily - ([87ab905](https://github.com/arxdeus/modulisto/commit/87ab905742fff89f2fccc732086ef473dd136b23))

### Miscellaneous Chores

- **(debug)** `debugReportOperationTypeMismatch` naming - ([1447224](https://github.com/arxdeus/modulisto/commit/1447224c8f16882d2a235feede5ff61329aceaaa))
- **(operation)** future like operation handle - ([b828fb5](https://github.com/arxdeus/modulisto/commit/b828fb504cec40081aa5ce6ba1ac73dde6a4757f))
- **(subject)** `unawaited` instead of `ignore` - ([3408537](https://github.com/arxdeus/modulisto/commit/34085376d709941c30d3c1c6b40e335e26a10777))
- **(trigger)** export `nothingValue` for empty payload - ([26c69ae](https://github.com/arxdeus/modulisto/commit/26c69ae20d3d14cc7dc13afe3929fa6c5de52fbc))
- remove `Disposable` on `OperationRunner` - ([44a927e](https://github.com/arxdeus/modulisto/commit/44a927eb292539b979bfa342f013780eda4d6682))

### Refactoring

- **(map_store)** `setKeyValue` instead of `setValue` - ([66feb26](https://github.com/arxdeus/modulisto/commit/66feb263dad38eeee7b33137943dfdadcbfe58a3))
- **(pipeline)** split ref for pipelines - ([e7cd1c2](https://github.com/arxdeus/modulisto/commit/e7cd1c2b4fb3959ab84b64ca844b23b11c6753c6))
- **(pipeline)** split pipelines and contexts to less coupling - ([60981e7](https://github.com/arxdeus/modulisto/commit/60981e75a5f149a9813e7d3d5964ff077b003440))

### Tests

- fuzzy async group - ([1971a79](https://github.com/arxdeus/modulisto/commit/1971a79ffccda216fd503a71d7a4e317ab1dcb91))
- refactor tests after applying new analyzer rules - ([61d4bec](https://github.com/arxdeus/modulisto/commit/61d4becd30fa3e0095bed0e531748e5fb5db23a5))

---
## [2.4.0](https://github.com/arxdeus/modulisto/compare/modulisto-v2.3.0..2.4.0) - 2025-03-16

### Bug Fixes

- `PipelineRef` now implements `ModuleChild` - ([abfa596](https://github.com/arxdeus/modulisto/commit/abfa5961f90d421a957dc2083cd752551aed61eb))
- add missing export for `settings.dart` - ([b4be30f](https://github.com/arxdeus/modulisto/commit/b4be30f3ce08ccdab403ef939e43f3e5ce921bad))

### Features

- **(operation)** expando nullify at dispose + tests - ([78e039a](https://github.com/arxdeus/modulisto/commit/78e039a028d6579f522207e0b862883406b7b344))
- `Operation<T>` - special indirect unit that wraps around functions - ([70b43ed](https://github.com/arxdeus/modulisto/commit/70b43ed44b6ba972a0b9b7cca056cae6acc64a8e))
- pipeline linker for `Operation<T>` - ([a964f68](https://github.com/arxdeus/modulisto/commit/a964f6859636535713a0008ea4ef8d49e7b91c64))
- settings for package + `debugReportTypeMismatchOnOperation` - ([b049543](https://github.com/arxdeus/modulisto/commit/b04954371cc4ad2d2482022ea29687a720ac0fde))
- integrate `OperationRunner` in `Module` - ([daba526](https://github.com/arxdeus/modulisto/commit/daba5269c170e08a9537fca812caf4ddfdbdb6b9))
- hide `debugName` + assign `debugName` to `Module` on `initialize` - ([779dca9](https://github.com/arxdeus/modulisto/commit/779dca9777342a8df65500310d47c132fb14ad23))
- operation tests - ([921d995](https://github.com/arxdeus/modulisto/commit/921d995c968fbebbfaa9cb3afe243f348dc07f18))

### Miscellaneous Chores

- mark `module` with `$` as internal marker - ([c4898e5](https://github.com/arxdeus/modulisto/commit/c4898e5680597e16a0c337f1f4423cc94d873964))

### Ci

- major update + fix lints - ([7329f15](https://github.com/arxdeus/modulisto/commit/7329f153d6608ba43e7639277d72aed62e36bbe4))

## 2.2.1

* fix: remove unneccessary flutter sdk constraint in `pubspec.yaml`
* chore: rename `CloseableStreamWrapper` to `ClosableStreamWrapper`

## 2.2.0

* feat: `UnitAdapter<Unit>.stream()` returns `CloseableStreamWrapper` that allows us to interact only with underlying `.stream` and `.close`
* feat: `UnitAdapter<Store>.stream(emitFirstImmediately: true)` will return `Subject` wrapped into `CloseableStreamWrapper`
* feat: `Subject<T>` - lightweight alternative of `BehaviorSubject` from `rxdart`, emits last value on each new `StreamSubcription`

## 2.1.0

* feat: extendable `UnitAdapter` that allows convertation of `Unit` into several other types
* refactor: make `interfaces.dart` more clean looking
* docs: doc-comments for `interfaces.dart`

## 2.0.2

* docs: actualize documentation for `2.0.*`

## 2.0.1
* feat(sync_pipeline): `StreamPipelineLinker` in `SyncPipeline`

## 2.0.0

* feat!(pipeline): new system of working with custom types in `Pipeline` - `PipelineLinker`
* feat!(pipeline): introduce two built-in linkers: `StreamPipelineLinker` and `UnitPipelineLinker`
* feat!(pipeline): changed linkers signature in `Pipeline`' constructors, relevant type comes first and then goes by method of subscription
* fix!(unit): `Unit<T>` now is just `ValueListenable<T>` from Flutter SDK, that means that it doesn't `extends Stream<T>`
* refactor(unit): reduce count of asynchronous calls in `Unit` lifecycle
* refactor(module): `Pipeline`'s queued by type for `.dispose`: `AsyncPipeline` disposes first, then `SyncPipeline` goes off too

## 1.1.0

* refactor: `Set<Attachable>` instead of attach callback in `Module.initialize`

## 1.0.2

* docs: fullpledged `README.md`

## 1.0.1

* feat: `PipelineContext` can `.update` any `Updatable<T>` interface implementation

## 1.0.0

* feat: `Trigger<T>` as executive `Unit`
* feat: `Store<T>` as storage `Unit`
* feat: `Pipeline` as flow handler (both `.async` and `.sync`)
* feat: `ModuleLifecycle` that allows you to react on module lifecycle updates
