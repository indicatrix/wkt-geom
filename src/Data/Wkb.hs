-- Refer to the WKB Wikipedia page <https://en.wikipedia.org/wiki/Well-known_text#Well-known_binary>
--
-- Allows parsing of ByteString into a Geospatial Object.
--
-------------------------------------------------------------------
module Data.Wkb
  ( parseByteString
  , parseHexByteString
  , toByteString
  ) where

import qualified Data.Binary.Get              as BinaryGet
import qualified Data.ByteString.Builder      as ByteStringBuilder
import qualified Data.ByteString.Lazy         as LazyByteString
import qualified Data.Geospatial              as Geospatial

import qualified Data.Internal.Wkb.Endian     as Endian
import qualified Data.Internal.Wkb.Geometry   as Geometry
import qualified Data.Internal.Wkb.Geospatial as WkbGeospatial

import qualified Data.Hex                     as Hex

-- |
-- Representation of WKB as Binary
parseByteString :: LazyByteString.ByteString -> Either String Geospatial.GeospatialGeometry
parseByteString byteString =
  case BinaryGet.runGetOrFail
        (WkbGeospatial.getGeospatialGeometry Geometry.getGeometryTypeWithCoords)
        byteString of
    Left (_, _, err)                 -> Left $ "Could not parse wkb: " ++ err
    Right (_, _, geoSpatialGeometry) -> Right geoSpatialGeometry

-- |
-- Representation of WKB as a String in Base16/Hex form i.e. "0101000000000000000000f03f0000000000000040" is POINT 1.0 2.0
parseHexByteString :: Hex.Hex -> Either String Geospatial.GeospatialGeometry
parseHexByteString = Hex.safeConvert parseByteString

toByteString :: Endian.EndianType -> Geospatial.GeospatialGeometry -> LazyByteString.ByteString
toByteString endianType =
  ByteStringBuilder.toLazyByteString . WkbGeospatial.builderGeospatialGeometry endianType
