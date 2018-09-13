{-# LANGUAGE OverloadedStrings #-}

module Data.Wkb.GeometryCollectionSpec where

import qualified Data.ByteString.Builder as ByteStringBuilder
import qualified Data.ByteString.Lazy    as LazyByteString
import qualified Data.Geospatial         as Geospatial
import           Data.Monoid             ((<>))
import qualified Data.Vector             as Vector
import           Test.Hspec              (Spec, describe, it, shouldBe)

import qualified Data.Wkb                as Wkb

import qualified Data.SpecHelper         as SpecHelper

spec :: Spec
spec =
  testWkbGeometryCollectionParsing

testWkbGeometryCollectionParsing :: Spec
testWkbGeometryCollectionParsing =
  describe "Test wkb geometry collection" $
    it "Parse valid wkb geometry collection" $
      Wkb.parseByteString exampleWkbGeometryCollection `shouldBe` (Right . Geospatial.Collection $
        Vector.fromList
          [ Geospatial.Point $ Geospatial.GeoPoint SpecHelper.point1
          , Geospatial.Point $ Geospatial.GeoPoint SpecHelper.point2
          , Geospatial.Line $ Geospatial.GeoLine SpecHelper.lineString3
          ]
        )

exampleWkbGeometryCollection :: LazyByteString.ByteString
exampleWkbGeometryCollection =
  ByteStringBuilder.toLazyByteString $
    ByteStringBuilder.word8 0
    <> ByteStringBuilder.int32BE 7
    <> ByteStringBuilder.int32BE 3
    <> ByteStringBuilder.word8 0
    <> ByteStringBuilder.int32BE 1
    <> ByteStringBuilder.doubleBE 10
    <> ByteStringBuilder.doubleBE 10
    <> ByteStringBuilder.word8 0
    <> ByteStringBuilder.int32BE 1
    <> ByteStringBuilder.doubleBE 30
    <> ByteStringBuilder.doubleBE 30
    <> ByteStringBuilder.word8 0
    <> ByteStringBuilder.int32BE 2
    <> ByteStringBuilder.int32BE 3
    <> ByteStringBuilder.doubleBE 15
    <> ByteStringBuilder.doubleBE 15
    <> ByteStringBuilder.doubleBE 20
    <> ByteStringBuilder.doubleBE 20
    <> ByteStringBuilder.doubleBE 25
    <> ByteStringBuilder.doubleBE 25
