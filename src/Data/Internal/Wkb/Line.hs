module Data.Internal.Wkb.Line
  ( Data.Internal.Wkb.Line.line
  , multiLine
  ) where

import qualified Control.Monad                        as Monad
import qualified Data.Binary.Get                      as BinaryGet
import qualified Data.Geospatial                      as Geospatial
import qualified Data.LineString                      as LineString
import qualified Data.Sequence                        as Sequence

import qualified Data.Internal.Wkb.Endian             as Endian
import qualified Data.Internal.Wkb.Geometry           as Geometry
import qualified Data.Internal.Wkb.GeometryCollection as GeometryCollection
import qualified Data.Internal.Wkb.Point              as Point

line :: Endian.EndianType -> Geometry.CoordinateType -> BinaryGet.Get Geospatial.GeospatialGeometry
line endianType coordType = do
  gl <- geoLine endianType coordType
  pure $ Geospatial.Line gl

multiLine :: (Endian.EndianType -> BinaryGet.Get Geometry.WkbGeometryType) -> Endian.EndianType -> Geometry.CoordinateType -> BinaryGet.Get Geospatial.GeospatialGeometry
multiLine getWkbGeom endianType _ = do
  numberOfLines <- Endian.getFourBytes endianType
  geoLines <- Sequence.replicateM (fromIntegral numberOfLines) (GeometryCollection.enclosedFeature getWkbGeom Geometry.LineString geoLine)
  pure $ Geospatial.MultiLine $ Geospatial.mergeGeoLines geoLines

geoLine :: Endian.EndianType -> Geometry.CoordinateType -> BinaryGet.Get Geospatial.GeoLine
geoLine endianType coordType = do
  numberOfPoints <- Endian.getFourBytes endianType
  if numberOfPoints >= 2 then do
    p1 <- Point.getCoordPoint endianType coordType
    p2 <- Point.getCoordPoint endianType coordType
    pts <- Point.getCoordPoints endianType coordType (numberOfPoints - 2)
    pure $ Geospatial.GeoLine $ LineString.makeLineString p1 p2 pts
  else
    Monad.fail "Must have at least two points for a line"
