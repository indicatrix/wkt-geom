module Data.Wkb where

import qualified Data.Binary.Get      as BinaryGet
import qualified Data.ByteString.Lazy as LazyByteString
import qualified Data.Geospatial      as Geospatial

import qualified Data.Wkb.Endian      as Endian
import qualified Data.Wkb.Geometry    as Geometry
import qualified Data.Wkb.Point       as Point

parseByteString :: LazyByteString.ByteString -> Either String Geospatial.GeospatialGeometry
parseByteString byteString =
  let
    geoSpatialGeometryResult = do
      (unconsumedInput, _, endianType)
        <- BinaryGet.runGetOrFail Endian.getEndianType byteString
      (_, _, geoSpatialGeometry)
        <- BinaryGet.runGetOrFail (getGeoSpatialGeometry endianType) unconsumedInput
      pure geoSpatialGeometry
  in
    case geoSpatialGeometryResult of
      Left (_, _, err) -> Left $ "Could not parse wkb: " ++ err
      Right x          -> Right x

getGeoSpatialGeometry :: Endian.EndianType -> BinaryGet.Get Geospatial.GeospatialGeometry
getGeoSpatialGeometry endianType = do
  geometryTypeWithCoords <- Geometry.getGeometryTypeWithCoords endianType
  let (Geometry.WkbGeom geomType coordType) = geometryTypeWithCoords
  getter geomType endianType coordType
  where
    getter geomType =
      case geomType of
        Geometry.WkbGeometry           -> undefined
        Geometry.WkbPoint              -> Point.getPoint
        Geometry.WkbLineString         -> undefined
        Geometry.WkbPolygon            -> undefined
        Geometry.WkbMultiPoint         -> Point.getMultiPoint
        Geometry.WkbMultiLineString    -> undefined
        Geometry.WkbMultiPolygon       -> undefined
        Geometry.WkbGeometryCollection -> undefined
