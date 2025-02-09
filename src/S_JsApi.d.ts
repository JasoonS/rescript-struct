export class StructError extends Error {}

export type Result<Value> =
  | {
      success: true;
      value: Value;
    }
  | { success: false; error: StructError };

export interface Struct<Value> {
  parse(data: unknown): Result<Value>;
  parseOrThrow(data: unknown): Value;
  parseAsync(data: unknown): Promise<Result<Value>>;
  serialize(data: Value): Result<unknown>;
  serializeOrThrow(data: Value): unknown;
  transform<Transformed>(
    parser: (value: Value) => Transformed
  ): Struct<Transformed>;
  transform<Transformed>(
    parser: ((value: Value) => Transformed) | undefined,
    serializer: (transformed: Transformed) => Value
  ): Struct<Transformed>;
  refine(parser: (value: Value) => void): Struct<Value>;
  refine(
    parser: ((value: Value) => void) | undefined,
    serializer: (value: Value) => void
  ): Struct<Value>;
  asyncRefine(parser: (value: Value) => Promise<void>): Struct<Value>;
  optional(): Struct<Value | undefined>;
  nullable(): Struct<Value | undefined>;
  describe(description: string): Struct<Value>;
  description(): string | undefined;
  default(def: () => NoUndefined<Value>): Struct<NoUndefined<Value>>;
}

export type Infer<T> = T extends Struct<infer Value> ? Value : never;

export type Json =
  | string
  | boolean
  | number
  | null
  | { [key: string]: Json }
  | Json[];

type NoUndefined<T> = T extends undefined ? never : T;
type AnyStruct = Struct<unknown>;
type InferStructTuple<
  Tuple extends AnyStruct[],
  Length extends number = Tuple["length"]
> = Length extends Length
  ? number extends Length
    ? Tuple
    : _InferTuple<Tuple, Length, []>
  : never;
type _InferTuple<
  Tuple extends AnyStruct[],
  Length extends number,
  Accumulated extends unknown[],
  Index extends number = Accumulated["length"]
> = Index extends Length
  ? Accumulated
  : _InferTuple<Tuple, Length, [...Accumulated, Infer<Tuple[Index]>]>;

export interface ObjectStruct<Value> extends Struct<Value> {
  strip(): ObjectStruct<Value>;
  strict(): ObjectStruct<Value>;
}

export const string: Struct<string>;
export const boolean: Struct<boolean>;
export const integer: Struct<number>;
export const number: Struct<number>;
export const never: Struct<never>;
export const unknown: Struct<unknown>;
export const json: Struct<Json>;
export const nan: Struct<undefined>;

export function literal<Value extends string>(value: Value): Struct<Value>;
export function literal<Value extends number>(value: Value): Struct<Value>;
export function literal<Value extends boolean>(value: Value): Struct<Value>;
export function literal(value: undefined): Struct<undefined>;
export function literal(value: null): Struct<undefined>;
export function tuple(structs: []): Struct<undefined>;
export function tuple<Value>(structs: [Struct<Value>]): Struct<Value>;
export function tuple<A extends AnyStruct, B extends AnyStruct[]>(
  structs: [A, ...B]
): Struct<[Infer<A>, ...InferStructTuple<B>]>;

export const optional: <Value>(
  struct: Struct<Value>
) => Struct<Value | undefined>;

export const nullable: <Value>(
  struct: Struct<Value>
) => Struct<Value | undefined>;

export const array: <Value>(struct: Struct<Value>) => Struct<Value[]>;

export const record: <Value>(
  struct: Struct<Value>
) => Struct<Record<string, Value>>;

export const jsonString: <Value>(struct: Struct<Value>) => Struct<Value>;

export const union: <A extends AnyStruct, B extends AnyStruct[]>(
  structs: [A, ...B]
) => Struct<Infer<A> | InferStructTuple<B>[number]>;

export const object: <Value>(shape: {
  [k in keyof Value]: Struct<Value[k]>;
}) => ObjectStruct<{
  [k in keyof Value]: Value[k];
}>;

export const custom: <Value>(
  name: string,
  parser?: (data: unknown) => Value,
  serializer?: (value: Value) => unknown
) => Struct<Value>;

export const fail: (reason: string) => void;
