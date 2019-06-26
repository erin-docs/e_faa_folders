view: aircraft_engines {
  sql_table_name: flightstats.aircraft_engines ;;

  dimension: aircraft_engine_code {
    type: string
    sql: ${TABLE}.aircraft_engine_code ;;
  }

  dimension: aircraft_engine_type_id {
    type: yesno
    # hidden: yes
    sql: ${TABLE}.aircraft_engine_type_id ;;
  }

  dimension: fuel_consumed {
    type: number
    sql: ${TABLE}.fuel_consumed ;;
  }

  dimension: horsepower {
    type: number
    sql: ${TABLE}.horsepower ;;
  }

  dimension: manufacturer {
    type: string
    sql: ${TABLE}.manufacturer ;;
  }

  dimension: model {
    type: string
    sql: ${TABLE}.model ;;
  }

  dimension: thrust {
    type: number
    sql: ${TABLE}.thrust ;;
  }

  measure: count {
    type: count
    drill_fields: [aircraft_engine_types.aircraft_engine_type_id]
  }
}
