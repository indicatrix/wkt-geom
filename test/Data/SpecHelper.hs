module Data.SpecHelper where

import qualified Data.Geospatial as Geospatial
import qualified Data.LinearRing as LinearRing
import qualified Data.LineString as LineString
import qualified Data.Vector     as Vector

point1 :: Geospatial.GeoPositionWithoutCRS
point1 = Geospatial.GeoPointXY (Geospatial.PointXY 1.0 2.0)

point2 :: Geospatial.GeoPositionWithoutCRS
point2 = Geospatial.GeoPointXY (Geospatial.PointXY 3.0 4.0)

lineString1 :: LineString.LineString Geospatial.GeoPositionWithoutCRS
lineString1 = LineString.makeLineString (Geospatial.GeoPointXY (Geospatial.PointXY 1.0 2.0)) (Geospatial.GeoPointXY (Geospatial.PointXY 3.0 4.0)) Vector.empty

lineString2 :: LineString.LineString Geospatial.GeoPositionWithoutCRS
lineString2 = LineString.makeLineString (Geospatial.GeoPointXY (Geospatial.PointXY 1.5 2.5)) (Geospatial.GeoPointXY (Geospatial.PointXY 3.5 4.5)) Vector.empty

lineString3 :: LineString.LineString Geospatial.GeoPositionWithoutCRS
lineString3 = LineString.makeLineString (Geospatial.GeoPointXY (Geospatial.PointXY 15 15)) (Geospatial.GeoPointXY (Geospatial.PointXY 20 20)) (Vector.singleton (Geospatial.GeoPointXY (Geospatial.PointXY 20 20)))

linearRing1 :: LinearRing.LinearRing Geospatial.GeoPositionWithoutCRS
linearRing1 = LinearRing.makeLinearRing (Geospatial.GeoPointXY (Geospatial.PointXY 1.0 2.0)) (Geospatial.GeoPointXY (Geospatial.PointXY 3.0 4.0)) (Geospatial.GeoPointXY (Geospatial.PointXY 5.0 6.0)) Vector.empty

linearRing2 :: LinearRing.LinearRing Geospatial.GeoPositionWithoutCRS
linearRing2 = LinearRing.makeLinearRing (Geospatial.GeoPointXY (Geospatial.PointXY 1.5 2.5)) (Geospatial.GeoPointXY (Geospatial.PointXY 3.5 4.5)) (Geospatial.GeoPointXY (Geospatial.PointXY 5.5 6.5)) Vector.empty
