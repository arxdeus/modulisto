# Changelog

---
## [2.4.0](https://github.com/arxdeus/modulisto/compare/modulisto-v2.3.0..2.4.0) - 2025-03-16

### Bug Fixes

- `PipelineRef` now implements `ModuleChild` - ([abfa596](https://github.com/arxdeus/modulisto/commit/abfa5961f90d421a957dc2083cd752551aed61eb))
- add missing export for `settings.dart` - ([b4be30f](https://github.com/arxdeus/modulisto/commit/b4be30f3ce08ccdab403ef939e43f3e5ce921bad))
- ignore lint - ([91e8fab](https://github.com/arxdeus/modulisto/commit/91e8fab2a118183cb443013ab7888efaf478d32c))

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

- modify flow - ([c64c526](https://github.com/arxdeus/modulisto/commit/c64c5269288660f05781c413cc128910293bb942))

---
## [2.4.0](https://github.com/arxdeus/modulisto/compare/modulisto-v2.3.0..2.4.0) - 2025-03-16

### Bug Fixes

- `PipelineRef` now implements `ModuleChild` - ([abfa596](https://github.com/arxdeus/modulisto/commit/abfa5961f90d421a957dc2083cd752551aed61eb))
- add missing export for `settings.dart` - ([b4be30f](https://github.com/arxdeus/modulisto/commit/b4be30f3ce08ccdab403ef939e43f3e5ce921bad))
- ignore lint - ([91e8fab](https://github.com/arxdeus/modulisto/commit/91e8fab2a118183cb443013ab7888efaf478d32c))

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
