VERSION_OR_BRANCH=$1
MINOR_VERSION=$2

ARTIFACT_BUNDLE_NAME="swift-format.artifactbundle"
MACOS_FOLDER_PATH="swift-format-$VERSION_OR_BRANCH-macos"

git checkout -b "release/$VERSION_OR_BRANCH-$MINOR_VERSION"
git clone git@github.com:apple/swift-format.git

cd swift-format
swift build -c release --arch arm64 --arch x86_64

mkdir $ARTIFACT_BUNDLE_NAME
mkdir $ARTIFACT_BUNDLE_NAME/$MACOS_FOLDER_PATH
mkdir $ARTIFACT_BUNDLE_NAME/$MACOS_FOLDER_PATH/bin

cp .build/apple/Products/Release/swift-format ./$ARTIFACT_BUNDLE_NAME/$MACOS_FOLDER_PATH/bin/swift-format

sed 's/__VERSION__/'"${VERSION_OR_BRANCH}"'/g' ../spm-macos-artifact-bundle-info.template > ${ARTIFACT_BUNDLE_NAME}/info.json

zip -yr - $ARTIFACT_BUNDLE_NAME > "${ARTIFACT_BUNDLE_NAME}.zip"

rm -rf $ARTIFACT_BUNDLE_NAME

cd ..

git add "swift-format/${ARTIFACT_BUNDLE_NAME}.zip"
git commit -m "Release $VERSION_OR_BRANCH version"
git tag "$VERSION_OR_BRANCH-$MINOR_VERSION"
git push
