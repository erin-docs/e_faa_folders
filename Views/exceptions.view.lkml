view: exceptions {
  sql_table_name: flightstats.exceptions ;;

  dimension: bad_tail_num {
    type: string
    sql: ${TABLE}.bad_tail_num ;;
  }

  dimension: carrier {
    type: string
    sql: ${TABLE}.carrier ;;
  }

  dimension_group: first_seen {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.first_seen ;;
  }

  dimension: good_tail_num {
    type: string
    sql: ${TABLE}.good_tail_num ;;
  }

  dimension_group: last_seen {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.last_seen ;;
  }

  dimension: owner_name {
    type: string
    sql: ${TABLE}.owner_name ;;
  }

  measure: count {
    type: count
    drill_fields: [owner_name]
  }
}
