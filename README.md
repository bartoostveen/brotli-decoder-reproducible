# Reproducible builds for Brotli decoder

![Latest release](https://git.bartoostveen.nl/bart/brotli-decoder-reproducible/badges/workflows/publish.yml/badge.svg?label=Latest%20release&style=for-the-badge)
![Latest version](https://git.bartoostveen.nl/bart/brotli-decoder-reproducible/badges/release.svg?style=for-the-badge)

Since <https://github.com/google/brotli/tree/master/java> is still maintained, but not published to Maven Central anymore, I figured there'd be no harm in making a reproducible build for it and publishing it to my own registry.

## How to use

<details>
<summary>Using Maven</summary>

In your `pom.xml`:

```xml
<repositories>
 <repository>
  <id>bart-forgejo</id>
  <url>https://git.bartoostveen.nl/api/packages/bart/maven</url>
 </repository>
</repositories>

<distributionManagement>
 <repository>
  <id>bart-forgejo</id>
  <url>https://git.bartoostveen.nl/api/packages/bart/maven</url>
 </repository>

 <snapshotRepository>
  <id>bart-forgejo</id>
  <url>https://git.bartoostveen.nl/api/packages/bart/maven</url>
 </snapshotRepository>
</distributionManagement>
```

Then, add the following in your `<dependencies>` block:

```xml
<dependency>
 <groupId>org.brotli</groupId>
 <artifactId>dec</artifactId>
 <version>1.2.1-unstable-2026-10-28</version>
</dependency>
```

The version in the example above is likely to be out of date, so replace it with the following version to use the latest:

![Latest version](https://git.bartoostveen.nl/bart/brotli-decoder-reproducible/badges/release.svg?style=for-the-badge)
</details>

<details open>
<summary>Using Gradle</summary>

In your `settings.gradle.kts`:

```kotlin
dependencyResolutionManagement {
    repositories {
        mavenCentral()
        maven("https://git.bartoostveen.nl/api/packages/bart/maven")
    }
}
```

Then, add the dependency in `build.gradle.kts` using:

```kotlin
implementation("org.brotli:dec:1.2.1-unstable-2026-10-28")
```

Or when using `libs.versions.toml` (version catalogs):

```toml
brotli = { module = "org.brotli:dec", version = "1.2.1-unstable-2026-10-28" }
```

The version in the example above is likely to be out of date, so replace it with the following version to use the latest:

![Latest version](https://git.bartoostveen.nl/bart/brotli-decoder-reproducible/badges/release.svg?style=for-the-badge)

</summary>

## License

All released code here is not licensed, as these are merely some build scripts. Refer to the upstream license: [MIT License](https://github.com/google/brotli/blob/master/LICENSE).
