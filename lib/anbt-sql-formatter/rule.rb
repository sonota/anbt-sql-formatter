# -*- coding: utf-8 -*-

require "anbt-sql-formatter/helper"

=begin
AnbtSqlFormatter: SQL整形ツール. SQL文を決められたルールに従い整形します。

フォーマットを実施するためには、入力されるSQLがSQL文として妥当であることが前提条件となります。

このクラスが準拠するSQL整形のルールについては、下記URLを参照ください。
http://homepage2.nifty.com/igat/igapyon/diary/2005/ig050613.html

このクラスは SQLの変換規則を表します。

@author WATANABE Yoshinori (a-san) : original version at 2005.07.04.
@author IGA Tosiki : marge into blanc Framework at 2005.07.04
@author sonota : porting to Ruby 2009-2010
=end

class AnbtSql
  class Rule

    include StringUtil

    attr_accessor :keyword, :indent_string, :function_names, :space_after_comma
    attr_accessor :kw_multi_words

    # nl: New Line
    # x: the keyword
    attr_accessor :kw_plus1_indent_x_nl
    attr_accessor :kw_minus1_indent_nl_x_plus1_indent
    attr_accessor :kw_nl_x
    attr_accessor :kw_nl_x_plus1_indent
    attr_accessor :kw_minus1_indent_nl_x

    # キーワードの変換規則: 何もしない
    KEYWORD_NONE = 0

    # キーワードの変換規則: 大文字にする
    KEYWORD_UPPER_CASE = 1

    # キーワードの変換規則: 小文字にする
    KEYWORD_LOWER_CASE = 2


    def initialize
      # キーワードの変換規則.
      @keyword = KEYWORD_LOWER_CASE

      # インデントの文字列. 設定は自由入力とする。
      # 通常は " ", " ", "\t" のいずれか。
      @indent_string = "    "

      @space_after_comma = true

      # __foo
      # ____KW
      @kw_plus1_indent_x_nl = %w(INSERT INTO CREATE DROP TRUNCATE TABLE CASE)

      # ____foo
      # __KW
      # ____bar
      @kw_minus1_indent_nl_x_plus1_indent = %w(FROM WHERE SET HAVING)
      #@kw_minus1_indent_nl_x_plus1_indent.concat ["SELECT DISTINCT", "UNION ALL"]

      # ____foo
      # __KW_bar
      @kw_minus1_indent_nl_x = ["ORDER BY"]#, "GROUP BY"]

      # __foo
      # ____KW
      @kw_nl_x_plus1_indent = %w(ON USING ROWS)

      # __foo
      # __KW_bar
      @kw_nl_x = %w(OR THEN ELSE WHEN JOIN)
      @kw_nl_x.concat ["LEFT JOIN", "RIGHT JOIN", "INNER JOIN",
        "FULL OUTER JOIN", "CROSS JOIN"]
      # @kw_nl_x = %w(OR WHEN ELSE) "ORDER BY", "GROUP BY",

      @kw_multi_words = ["ORDER BY", "GROUP BY", "LEFT JOIN", "RIGHT JOIN", "INNER JOIN",
        "FULL OUTER JOIN", "CROSS JOIN", "UNION ALL", "SELECT DISTINCT", "WITHIN GROUP"]

      # 関数の名前。
      # Java版は初期値 null
      @function_names =
        [
         # getNumericFunctions
         "ABS", "ACOS", "ASIN", "ATAN", "ATAN2", "BIT_COUNT", "CEILING",
         "COS", "COT", "DEGREES", "EXP", "FLOOR", "LOG", "LOG10",
         "MAX", "MIN", "MOD", "PI", "POW", "POWER", "RADIANS", "RAND",
         "ROUND", "SIN", "SQRT", "TAN", "TRUNCATE",
         # getStringFunctions
         "ASCII", "BIN", "BIT_LENGTH", "CHAR", "CHARACTER_LENGTH",
         "CHAR_LENGTH", "CONCAT", "CONCAT_WS", "CONV", "ELT",
         "EXPORT_SET", "FIELD", "FIND_IN_SET", "HEX,INSERT", "INSTR",
         "LCASE", "LEFT", "LENGTH", "LOAD_FILE", "LOCATE", "LOCATE",
         "LOWER", "LPAD", "LTRIM", "MAKE_SET", "MATCH", "MID", "OCT",
         "OCTET_LENGTH", "ORD", "POSITION", "QUOTE", "REPEAT",
         "REPLACE", "REVERSE", "RIGHT", "RPAD", "RTRIM", "SOUNDEX",
         "SPACE", "STRCMP", "SUBSTRING", "SUBSTRING", "SUBSTRING",
         "SUBSTRING", "SUBSTRING_INDEX", "TRIM", "UCASE", "UPPER",
         "SPLIT_PART", "REGEXP_COUNT", "REGEXP_INSTR", "REGEXP_REPLACE",
         "REGEXP_SUBSTR", "BTRIM", "STRPOS",
         # getSystemFunctions
         "DATABASE", "USER", "SYSTEM_USER", "SESSION_USER", "PASSWORD",
         "ENCRYPT", "LAST_INSERT_ID", "VERSION",
         # getTimeDateFunctions
         "DAYOFWEEK", "WEEKDAY", "DAYOFMONTH", "DAYOFYEAR", "MONTH",
         "DAYNAME", "MONTHNAME", "QUARTER", "WEEK", "YEAR", "HOUR",
         "MINUTE", "SECOND", "PERIOD_ADD", "PERIOD_DIFF", "TO_DAYS",
         "FROM_DAYS", "DATE_FORMAT", "TIME_FORMAT", "CURDATE",
         "CURRENT_DATE", "CURTIME", "CURRENT_TIME", "NOW", "SYSDATE",
         "CURRENT_TIMESTAMP", "UNIX_TIMESTAMP", "FROM_UNIXTIME",
         "SEC_TO_TIME", "TIME_TO_SEC", "DATEDIFF", "DATEADD", "DATE_TRUNC",
         # Redshift
         "NVL", "LISTAGG", "ROW_NUMBER", "OVER", "CAST", "IN", "COALESCE",
         "LAST_VALUE", "FIRST_VALUE", "LAG", "LEAD", "EXTRACT", "WITHIN GROUP",
         "COUNT", "SUM", "SUBSTR", "DATE", "AVG", "LEN", "DENSE_RANK", "LEAST",
         "GREATEST", "FUNC_SHA1", "JSON_EXTRACT_PATH_TEXT", "CEIL", "FLOOR",
         "NULLIF"
        ]
    end


    def function?(name)
      if (@function_names == nil)
        return false
      end

      for i in 0...(@function_names.length)
        if (equals_ignore_case(@function_names[i], name))
          return true
        end
      end

      return false
    end
  end
end
