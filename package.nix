{
  lib,
  maven,
  fetchFromGitHub,
  nix-update-script,
}:

maven.buildMavenPackage (finalAttrs: {
  pname = "brotli-dec";
  version = "1.2.1-unstable-2026-10-28";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "google";
    repo = "brotli";
    rev = "d89c4b1c52e25ddafe047bc78bbee5c1e24b1809";
    hash = "sha256-Gp0KbNwQ1qyt0FwyS4CJPi6zg/OAbIIQR5ZHFhJSw/c=";
    # Workaround for incorrect .gitattributes
    leaveDotGit = true;
  };

  mvnHash = "sha256-wTzcPDzY43KhKyIBNyNJJ5u5JxWtan1G9LSyaSeFaXM=";

  mvnParameters = lib.escapeShellArgs [
    "-f"
    "java/org/brotli/pom.xml"
    "-pl"
    "dec"
    "-am"
  ];

  postPatch = ''
    for pom in \
      java/org/brotli/pom.xml \
      java/org/brotli/dec/pom.xml
    do
      substituteInPlace "$pom" \
        --replace-fail \
          '1.2.0-SNAPSHOT' \
          '${finalAttrs.version}'
    done
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/java"
    mkdir -p "$out/share/maven-repository"

    install -Dm644 \
      java/org/brotli/dec/target/org.brotli.dec-${finalAttrs.version}.jar \
      "$out/share/java/org.brotli.dec-${finalAttrs.version}.jar"

    install -Dm644 \
      java/org/brotli/pom.xml \
      "$out/share/maven-repository/org/brotli/parent/${finalAttrs.version}/parent-${finalAttrs.version}.pom"

    install -Dm644 \
      java/org/brotli/dec/pom.xml \
      "$out/share/maven-repository/org/brotli/dec/${finalAttrs.version}/org.brotli.dec-${finalAttrs.version}.pom"

    install -Dm644 \
      java/org/brotli/dec/target/org.brotli.dec-${finalAttrs.version}.jar \
      "$out/share/maven-repository/org/brotli/dec/${finalAttrs.version}/org.brotli.dec-${finalAttrs.version}.jar"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch=main" ]; };

  meta = {
    description = "Brotli compression format";
    homepage = "https://github.com/google/brotli";
    changelog = "https://github.com/google/brotli/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bartoostveen ];
    platforms = lib.platforms.all;
  };
})
