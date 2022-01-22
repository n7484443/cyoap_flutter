import 'dart:math';

import 'ValueType.dart';

class Func_one_input extends Function {}

class Func_two_input extends Function {}

class Func_three_input extends Function {}

class FunctionList {
  Function getFunction(String s) {
    switch (s) {
      case "if" :
        return func_if;
      case "floor" :
        return func_floor;
      case "round" :
        return func_round;
      case "ceil" :
        return func_ceil;
      case "+" :
        return func_plus;
      case "-" :
        return func_minus;
      case "*" :
        return func_multi;
      case "/" :
        return func_div;
      case "==" :
        return func_isEqual;
      case "!=" :
        return func_isNotEqual;
      case ">" :
        return func_bigger;
      case "<" :
        return func_smaller;
      case ">=" :
        return func_bigger_equal;
      case "<=" :
        return func_smaller_equal;
      case "random" :
        return func_rand;
      default :
        return null;
    };
  }


  Func_two_input func_plus(a, b) {
    if (b == null) {
      System.err.println("null error!");
      return null;
    }
    if (a.type.equals(types.strings)) {
      a.data += b.data;
      return a;
    } else if (a.type.equals(b.type) &&
        (a.type.equals(types.ints) || a.type.equals(types.floats))) {
      float d1 = Float.parseFloat(a.data);
      float d2 = Float.parseFloat(b.data);
      if (a.type.equals(types.floats)) {
        a.data = (d1 + d2).toString();
      } else {
        a.data = (int)(d1 + d2).toString();
      }
      return a;
    } else if (a.type.equals(types.floats) && b.type.equals(types.ints)) {
      float d1 = Float.parseFloat(a.data);
      float d2 = Float.parseFloat(b.data);
      a.data = String.valueOf(d1 + d2);
      return a;
    } else if (b.type.equals(types.floats) && a.type.equals(types.ints)) {
      float d1 = Float.parseFloat(a.data);
      float d2 = Float.parseFloat(b.data);
      b.data = String.valueOf(d1 + d2);
      System.out.println(b.data);
      return b;
    } else {
      System.err.println("type error!");
      return null;
    }
  }

  Func_two_input func_minus(a, b) {
    if (b == null) {
      print("null error!\n");
      return null;
    }
    if (a.type.equals(b.type) &&
        (a.type.equals(types.ints) || a.type.equals(types.floats))) {
      float d1 = Float.parseFloat(a.data);
      float d2 = -Float.parseFloat(b.data);
      if (a.type.equals(types.floats)) {
        a.data = String.valueOf(d1 + d2);
      } else {
        a.data = String.valueOf((int)(d1 + d2));
      }
      return a;
    } else if (a.type.equals(types.floats) && b.type.equals(types.ints)) {
      float d1 = Float.parseFloat(a.data);
      float d2 = -Float.parseFloat(b.data);
      a.data = String.valueOf(d1 + d2);
      return a;
    } else if (b.type.equals(types.floats) && a.type.equals(types.ints)) {
      float d1 = Float.parseFloat(a.data);
      float d2 = -Float.parseFloat(b.data);
      b.data = String.valueOf(d1 + d2);
      return b;
    } else {
      System.err.println("type error!");
      return null;
    }
  }

  Func_two_input func_multi(a, b) {
    if (b == null) {
      System.err.println("null error!");
      return null;
    }
    if (a.type.equals(b.type) &&
        (a.type.equals(types.ints) || a.type.equals(types.floats))) {
      float d1 = Float.parseFloat(a.data);
      float d2 = Float.parseFloat(b.data);
      if (a.type.equals(types.floats)) {
        a.data = String.valueOf(d1 * d2);
      } else {
        a.data = String.valueOf((int)(d1 * d2));
      }
      return a;
    } else if (a.type.equals(types.floats) && b.type.equals(types.ints)) {
      float d1 = Float.parseFloat(a.data);
      float d2 = Float.parseFloat(b.data);
      a.data = String.valueOf(d1 * d2);
      return a;
    } else if (b.type.equals(types.floats) && a.type.equals(types.ints)) {
      float d1 = Float.parseFloat(a.data);
      float d2 = Float.parseFloat(b.data);
      b.data = String.valueOf(d1 * d2);
      return b;
    } else {
      System.err.println("type error!");
      return null;
    }
  }

  Func_two_input func_div(a, b) {
    if (b == null) {
      System.err.println("null error!");
      return null;
    }
    if (a.type.equals(b.type) &&
        (a.type.equals(types.ints) || a.type.equals(types.floats))) {
      float d1 = Float.parseFloat(a.data);
      float d2 = Float.parseFloat(b.data);
      if (a.type.equals(types.floats)) {
        a.data = String.valueOf(d1 / d2);
      } else {
        a.data = String.valueOf((int)(d1 / d2));
      }
      return a;
    } else if (a.type.equals(types.floats) && b.type.equals(types.ints)) {
      float d1 = Float.parseFloat(a.data);
      float d2 = Float.parseFloat(b.data);
      a.data = String.valueOf(d1 / d2);
      return a;
    } else if (b.type.equals(types.floats) && a.type.equals(types.ints)) {
      float d1 = Float.parseFloat(a.data);
      float d2 = Float.parseFloat(b.data);
      b.data = String.valueOf(d1 / d2);
      return b;
    } else {
      System.err.println("type error!");
      return null;
    }
  }

  double epsilon = 0.0001;

  Func_three_input func_if(bool, then, not) {
    if (bool == null) return null;
    if (bool.getData() == null) return null;
    return (boolean) bool.getData() ? then : not;
  }

  Func_two_input func_isEqual(a, b) {
    if (a == b) return new ValueType(true);
    if (a.type == types.ints && b.type == types.ints &&
        a.getData() == b.getData()) return new ValueType(true);
    if (a.type == types.floats && b.type == types.floats) {
      float a_data = a.getData();
      float b_data = b.getData();
      return new ValueType(
          Range.closed(-epsilon, epsilon).contains(a_data - b_data));
    }
    if (((a.type == types.ints && b.type == types.floats) ||
        (a.type == types.floats && b.type == types.ints))
        && a.getData() == b.getData()) return new ValueType(true);
    return new ValueType(false);
  }

  Func_two_input func_isNotEqual(a, b) {
    boolean bool_isEqaul = func_isEqual.func(a, b).getData();
    return new ValueType(!bool_isEqaul);
  }

  Func_two_input func_bigger_equal(a, b) {
    if (a.type == types.ints && b.type == types.ints) {
      int alpha = a.getData();
      int beta = b.getData();
      return new ValueType(alpha >= beta);
    } else if (a.type == types.floats && b.type == types.ints) {
      float alpha = a.getData();
      int beta = b.getData();
      return new ValueType(alpha >= beta);
    } else if (a.type == types.ints && b.type == types.floats) {
      int alpha = a.getData();
      float beta = b.getData();
      return new ValueType(alpha >= beta);
    } else if (a.type == types.floats && b.type == types.floats) {
      float alpha = a.getData();
      float beta = b.getData();
      return new ValueType(alpha >= beta);
    } else {
      return new ValueType(false);
    }
  }

  Func_two_input func_smaller_equal(a, b) {
    if (a.type == types.ints && b.type == types.ints) {
      int alpha = a.getData();
      int beta = b.getData();
      return new ValueType(alpha <= beta);
    } else if (a.type == types.floats && b.type == types.ints) {
      float alpha = a.getData();
      int beta = b.getData();
      return new ValueType(alpha <= beta);
    } else if (a.type == types.ints && b.type == types.floats) {
      int alpha = a.getData();
      float beta = b.getData();
      return new ValueType(alpha <= beta);
    } else if (a.type == types.floats && b.type == types.floats) {
      float alpha = a.getData();
      float beta = b.getData();
      return new ValueType(alpha <= beta);
    } else {
      return new ValueType(false);
    }
  }

  Func_two_input func_bigger(a, b) {
    boolean bool_isEqaul = func_smaller_equal.func(a, b).getData();
    return new ValueType(!bool_isEqaul);
  }

  Func_two_input func_smaller(a, b) {
    boolean bool_isEqaul = func_bigger_equal.func(a, b).getData();
    return new ValueType(!bool_isEqaul);
  }


  Func_one_input func_floor(input) {
    if (input.type == types.ints) {
      int f = input.getData();
      int i = (int) Math.floor(f);
      input.setData(String.valueOf(i));
      input.type = types.ints;
    } else if (input.type == types.floats) {
      float f = input.getData();
      int i = (int) Math.floor(f);
      input.setData(String.valueOf(i));
      input.type = types.ints;
    }
    return input;
  }


  Func_one_input func_round(input) {
    if (input.type == types.ints || input.type == types.floats) {
      int f = Math.round(input.getData());
      input.setData(String.valueOf(f));
      input.type = types.ints;
    }
    return input;
  }

  Func_one_input func_ceil(input) {
    if (input.type == types.ints || input.type == types.floats) {
      float f = input.getData();
      int i = (int) Math.ceil(f);
      input.setData(String.valueOf(i));
      input.type = types.ints;
    }
    return input;
  }

  Func_one_input func_rand(input) {
    double f;
    if (input.type.equals(types.ints)) {
      int i = input.getData();
      f = Random().nextInt(i) as double;
    } else {
      f = Random().nextDouble();
    }
    input.setData(f);
    return input;
  }
}
