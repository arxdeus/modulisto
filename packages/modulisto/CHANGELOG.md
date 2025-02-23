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
