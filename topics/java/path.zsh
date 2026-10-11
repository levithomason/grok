# openjdk@21 is keg-only: brew does not link it into $HOMEBREW_PREFIX/bin.
export JAVA_HOME="$HOMEBREW_PREFIX/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home"
export PATH="$HOMEBREW_PREFIX/opt/openjdk@21/bin:$PATH"
