// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Benchmark from "benchmark";
import * as S$RescriptStruct from "../src/S.bs.mjs";

function addWithPrepare(suite, name, fn) {
  return suite.add(name, fn(undefined));
}

function run(suite) {
  suite.on("cycle", (function ($$event) {
            console.log($$event.target.toString());
          })).run();
}

function makeTestObject() {
  return (Object.freeze({
    number: 1,
    negNumber: -1,
    maxNumber: Number.MAX_VALUE,
    string: 'string',
    longString:
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Vivendum intellegat et qui, ei denique consequuntur vix. Semper aeterno percipit ut his, sea ex utinam referrentur repudiandae. No epicuri hendrerit consetetur sit, sit dicta adipiscing ex, in facete detracto deterruisset duo. Quot populo ad qui. Sit fugit nostrum et. Ad per diam dicant interesset, lorem iusto sensibus ut sed. No dicam aperiam vis. Pri posse graeco definitiones cu, id eam populo quaestio adipiscing, usu quod malorum te. Ex nam agam veri, dicunt efficiantur ad qui, ad legere adversarium sit. Commune platonem mel id, brute adipiscing duo an. Vivendum intellegat et qui, ei denique consequuntur vix. Offendit eleifend moderatius ex vix, quem odio mazim et qui, purto expetendis cotidieque quo cu, veri persius vituperata ei nec. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
    boolean: true,
    deeplyNested: {
      foo: 'bar',
      num: 1,
      bool: false,
    },
  }));
}

function makeAdvancedObjectStruct() {
  return S$RescriptStruct.object(function (o) {
              return {
                      number: o.f("number", S$RescriptStruct.$$float),
                      negNumber: o.f("negNumber", S$RescriptStruct.$$float),
                      maxNumber: o.f("maxNumber", S$RescriptStruct.$$float),
                      string: o.f("string", S$RescriptStruct.string),
                      longString: o.f("longString", S$RescriptStruct.string),
                      boolean: o.f("boolean", S$RescriptStruct.bool),
                      deeplyNested: o.f("deeplyNested", S$RescriptStruct.object(function (o) {
                                return {
                                        foo: o.f("foo", S$RescriptStruct.string),
                                        num: o.f("num", S$RescriptStruct.$$float),
                                        bool: o.f("bool", S$RescriptStruct.bool)
                                      };
                              }))
                    };
            });
}

function makeAdvancedStrictObjectStruct() {
  return S$RescriptStruct.$$Object.strict(S$RescriptStruct.object(function (o) {
                  return {
                          number: o.f("number", S$RescriptStruct.$$float),
                          negNumber: o.f("negNumber", S$RescriptStruct.$$float),
                          maxNumber: o.f("maxNumber", S$RescriptStruct.$$float),
                          string: o.f("string", S$RescriptStruct.string),
                          longString: o.f("longString", S$RescriptStruct.string),
                          boolean: o.f("boolean", S$RescriptStruct.bool),
                          deeplyNested: o.f("deeplyNested", S$RescriptStruct.$$Object.strict(S$RescriptStruct.object(function (o) {
                                        return {
                                                foo: o.f("foo", S$RescriptStruct.string),
                                                num: o.f("num", S$RescriptStruct.$$float),
                                                bool: o.f("bool", S$RescriptStruct.bool)
                                              };
                                      })))
                        };
                }));
}

run(addWithPrepare(addWithPrepare(addWithPrepare(addWithPrepare(addWithPrepare(addWithPrepare(new (Benchmark.default.Suite)(), "Parse string", (function () {
                                  return function () {
                                    return S$RescriptStruct.parseAnyOrRaiseWith("Hello world!", S$RescriptStruct.string);
                                  };
                                })), "Serialize string", (function () {
                              return function () {
                                return S$RescriptStruct.serializeOrRaiseWith("Hello world!", S$RescriptStruct.string);
                              };
                            })).add("Advanced object struct factory", makeAdvancedObjectStruct), "Parse advanced object", (function () {
                        var struct = makeAdvancedObjectStruct(undefined);
                        var data = makeTestObject(undefined);
                        return function () {
                          return S$RescriptStruct.parseAnyOrRaiseWith(data, struct);
                        };
                      })), "Create and parse advanced object", (function () {
                    var data = makeTestObject(undefined);
                    return function () {
                      var struct = makeAdvancedObjectStruct(undefined);
                      return S$RescriptStruct.parseAnyOrRaiseWith(data, struct);
                    };
                  })), "Parse advanced strict object", (function () {
                var struct = makeAdvancedStrictObjectStruct(undefined);
                var data = makeTestObject(undefined);
                return function () {
                  return S$RescriptStruct.parseAnyOrRaiseWith(data, struct);
                };
              })), "Serialize advanced object", (function () {
            var struct = makeAdvancedObjectStruct(undefined);
            var data = makeTestObject(undefined);
            return function () {
              return S$RescriptStruct.serializeOrRaiseWith(data, struct);
            };
          })));

export {
  
}
/*  Not a pure module */
