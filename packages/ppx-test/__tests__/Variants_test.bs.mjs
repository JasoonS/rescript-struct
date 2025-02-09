// Generated by ReScript, PLEASE EDIT WITH CARE

import Ava from "ava";
import * as TestUtils from "./TestUtils.bs.mjs";
import * as S$RescriptStruct from "rescript-struct/src/S.bs.mjs";

var variantStruct = S$RescriptStruct.union([
      S$RescriptStruct.literalVariant({
            TAG: "String",
            _0: "One"
          }, "One"),
      S$RescriptStruct.literalVariant({
            TAG: "String",
            _0: "Two"
          }, "Two")
    ]);

Ava("Variant", (function (t) {
        TestUtils.assertEqualStructs(t, variantStruct, S$RescriptStruct.union([
                  S$RescriptStruct.literalVariant({
                        TAG: "String",
                        _0: "One"
                      }, "One"),
                  S$RescriptStruct.literalVariant({
                        TAG: "String",
                        _0: "Two"
                      }, "Two")
                ]), undefined, undefined);
      }));

var variantWithSingleItemStruct = S$RescriptStruct.literalVariant({
      TAG: "String",
      _0: "Single"
    }, "Single");

Ava("Variant with single item becomes a literal struct of the item", (function (t) {
        TestUtils.assertEqualStructs(t, variantWithSingleItemStruct, S$RescriptStruct.literalVariant({
                  TAG: "String",
                  _0: "Single"
                }, "Single"), undefined, undefined);
      }));

var variantWithAliasStruct = S$RescriptStruct.union([
      S$RescriptStruct.literalVariant({
            TAG: "String",
            _0: "하나"
          }, "One"),
      S$RescriptStruct.literalVariant({
            TAG: "String",
            _0: "Two"
          }, "Two")
    ]);

Ava("Variant with partial @as usage", (function (t) {
        TestUtils.assertEqualStructs(t, variantWithAliasStruct, S$RescriptStruct.union([
                  S$RescriptStruct.literalVariant({
                        TAG: "String",
                        _0: "하나"
                      }, "One"),
                  S$RescriptStruct.literalVariant({
                        TAG: "String",
                        _0: "Two"
                      }, "Two")
                ]), undefined, undefined);
      }));

export {
  variantStruct ,
  variantWithSingleItemStruct ,
  variantWithAliasStruct ,
}
/* variantStruct Not a pure module */
