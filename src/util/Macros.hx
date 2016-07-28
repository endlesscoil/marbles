package util;

import haxe.macro.Context;
import haxe.macro.Expr;

/* Based off of https://raw.githubusercontent.com/snowkit/mint/master/mint/core/Macros.hx */

class Macros {

    /*macro public static function def(value:Expr, def:Expr):Expr {
        return macro @:pos(Context.currentPos()) {
            if($value == null) $value = $def;
            $value;
        }
    }*/

    macro public static function def(value:Expr, def:Expr):Expr {
        return macro @:pos(Context.currentPos()) {
            ($value != null) ? $value : $def;
        }
    }

    macro public static function assert(expr:Expr, ?reason:ExprOf<String>) {
        #if !luxe_no_assertions
            var str = haxe.macro.ExprTools.toString(expr);

            reason = switch(reason) {
                case macro null: macro '';
                case _: macro ' ( ' + $reason + ' )';
            }

            return macro @:pos(Context.currentPos()) {
                if(!$expr) throw DebugError.assertion( '$str' + $reason);
            }
        #end
        return macro null;
    } //assert

    macro public static function assertnull(value:Expr, ?reason:ExprOf<String>) {
        #if !luxe_no_assertions
            var str = haxe.macro.ExprTools.toString(value);

            reason = switch(reason) {
                case macro null: macro '';
                case _: macro ' ( ' + $reason + ' )';
            }
            return macro @:pos(Context.currentPos()) {
                if($value == null) throw null_assertion('$str was null' + $reason);
            }
        #end
        return macro null;
    } //assertnull

} //Macros

enum DebugError {
    assertion(expr:String);
    null_assertion(expr:String);
}