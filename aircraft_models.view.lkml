view: aircraft_models {
  sql_table_name: flightstats.aircraft_models ;;

  dimension: aircraft_category_id {
    type: yesno
    sql: ${TABLE}.aircraft_category_id ;;
  }

  dimension: aircraft_engine_type_id {
    type: yesno
    # hidden: yes
    sql: ${TABLE}.aircraft_engine_type_id ;;
  }

  dimension: aircraft_model_code {
    type: string
    sql: ${TABLE}.aircraft_model_code ;;
  }

  dimension: aircraft_type_id {
    type: yesno
    # hidden: yes
    sql: ${TABLE}.aircraft_type_id ;;
  }

  dimension: amateur {
    type: yesno
    sql: ${TABLE}.amateur ;;
  }

  dimension: engines {
    type: yesno
    sql: ${TABLE}.engines ;;
  }

  dimension: manufacturer {
    type: string
    sql: ${TABLE}.manufacturer ;;
  }

  dimension: model {
    type: string
    sql: ${TABLE}.model ;;
  }

  dimension: seats {
    type: number
    sql: ${TABLE}.seats ;;
  }

  dimension: speed {
    type: number
    sql: ${TABLE}.speed ;;
  }

  dimension: weight {
    type: number
    sql: ${TABLE}.weight ;;
  }

  measure: count {
    type: count
    drill_fields: [aircraft_types.aircraft_type_id, aircraft_engine_types.aircraft_engine_type_id]
  }
}
