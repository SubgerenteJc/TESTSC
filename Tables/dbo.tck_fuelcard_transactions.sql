CREATE TABLE [dbo].[tck_fuelcard_transactions]
(
[sn] [int] NOT NULL IDENTITY(1, 1),
[vendor] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[type] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[packet] [varchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[customer_card_number] [varchar] (26) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_reply_code] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_transaction_code] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_message_text] [varchar] (78) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_request_class] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_outsource_id] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_account_number] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_user_id] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_user_pin] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_transaction_id] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_timestamp] [datetime] NULL,
[tck_card_number] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_card_number_sb] [int] NULL,
[tck_driver_id] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_driver_id_sb] [int] NULL,
[tck_driver_cdl] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_driver_cdl_sb] [int] NULL,
[tck_driver_name] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_driver_name_sb] [int] NULL,
[tck_truck_number] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_truck_number_sb] [int] NULL,
[tck_trailer_number] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_trailer_number_sb] [int] NULL,
[tck_card_status] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_card_status_sb] [int] NULL,
[tck_card_grp_number] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_card_grp_number_sb] [int] NULL,
[tck_us_fuel_flag] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_us_fuel_sb] [int] NULL,
[tck_card_daily_dollar_limit] [float] NULL,
[tck_card_daily_dollar_limit_sb] [int] NULL,
[tck_card_type] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_card_type_sb] [int] NULL,
[tck_driver_cdl_state] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_driver_cdl_state_sb] [int] NULL,
[tck_refreshing_cash_limit] [float] NULL,
[tck_refreshing_cash_limit_sb] [int] NULL,
[tck_refreshing_cash_refresh_type] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_refreshing_cash_refresh_type_sb] [int] NULL,
[tck_refreshing_cash_refresh_days] [varchar] (14) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_refreshing_cash_refresh_days_sb] [int] NULL,
[tck_dash_cash_balance] [float] NULL,
[tck_dash_cash_balance_sb] [int] NULL,
[tck_driver_message] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_driver_message_sb] [int] NULL,
[tck_dash_cash_memo] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_dash_cash_memo_sb] [int] NULL,
[tck_driver_pin] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_driver_pin_sb] [int] NULL,
[tck_daily_maximum_cash_limit] [float] NULL,
[tck_daily_maximum_cash_limit_sb] [int] NULL,
[tck_other_id] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_other_id_sb] [int] NULL,
[tck_debit_dollar_balance] [float] NULL,
[tck_debit_dollar_balance_sb] [int] NULL,
[tck_atm_flag] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_atm_flag_sb] [int] NULL,
[tck_incr_dash_cash_balance] [float] NULL,
[tck_incr_dash_cash_balance_sb] [int] NULL,
[tck_daily_unit_fuel_volume_limit] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_daily_unit_fuel_volume_limit_sb] [int] NULL,
[tck_odometer] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_odometer_sb] [int] NULL,
[tck_trip_number] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_trip_number_sb] [int] NULL,
[tck_trip_limit] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_trip_limit_sb] [int] NULL,
[tck_trip_begin_date] [datetime] NULL,
[tck_trip_begin_date_sb] [int] NULL,
[tck_trip_end_date] [datetime] NULL,
[tck_trip_end_date_sb] [int] NULL,
[tck_offnet_flag] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_offnet_flag_sb] [int] NULL,
[tck_diesel1_flag] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_diesel1_flag_sb] [int] NULL,
[tck_diesel2_flag] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_diesel2_flag_sb] [int] NULL,
[tck_dyed_diesel_flag] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_dyed_diesel_sb] [int] NULL,
[tck_dyed_gas_flag] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_dyed_gas_sb] [int] NULL,
[tck_gas_flag] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_gas_sb] [int] NULL,
[tck_volume_exempt_flag] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_volume_exempt_sb] [int] NULL,
[tck_unit_fuel_volume_limit_per_tran] [float] NULL,
[tck_unit_fuel_volume_limit_per_tran_sb] [int] NULL,
[tck_model_number] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_model_number_sb] [int] NULL,
[tck_Weekly_product_refresh_flag] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_Weekly_product_refresh_flag_sb] [int] NULL,
[tck_Weekly_product_refresh_day] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_Weekly_product_refresh_day_sb] [int] NULL,
[tck_Weekly_product_dollar_limit] [float] NULL,
[tck_Weekly_product_dollar_limit_sb] [int] NULL,
[tck_non_highway_fuel_daily_dollar_limit] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_non_highway_fuel_daily_dollar_limit_sb] [int] NULL,
[tck_non_highway_fuel_daily_volume_limit] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_non_highway_fuel_daily_volume_limit_sb] [int] NULL,
[tck_card_last_change_date] [datetime] NULL,
[tck_card_last_change_userid] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_cust_card_last_change_date] [datetime] NULL,
[tck_cust_card_last_change_userid] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_card_last_used_date] [datetime] NULL,
[tck_card_expire_date] [datetime] NULL,
[tck_driver_last_change_date] [datetime] NULL,
[tck_driver_last_change_userid] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_cust_driver_last_change_date] [datetime] NULL,
[tck_cust_driver_last_change_userid] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_paychek_dollar_balance] [float] NULL,
[tck_driver_dollar_usage] [float] NULL,
[tck_driver_last_use_date] [datetime] NULL,
[tck_last_cash_refresh_date] [datetime] NULL,
[tck_debit_dollar_refresh_date] [datetime] NULL,
[tck_unit_change_date] [datetime] NULL,
[tck_unit_change_userid] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_cust_unit_change_date] [datetime] NULL,
[tck_cust_unit_change_userid] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_unit_dollar_usage] [float] NULL,
[tck_unit_fuel_volume_usage] [float] NULL,
[tck_unit_last_use_date] [datetime] NULL,
[tck_Weekly_product_balance] [float] NULL,
[tck_last_Weekly_refresh_date] [datetime] NULL,
[tck_trailer_change_date] [datetime] NULL,
[tck_trailer_change_userid] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_cust_trlr_change_date] [datetime] NULL,
[tck_cust_trlr_change_userid] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_non_highway_dollar_usage] [float] NULL,
[tck_non_highway_fuel_volume_limit] [float] NULL,
[tck_trailer_use_date] [datetime] NULL,
[tck_currency_indicator] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tck_paychek_upload_amount] [float] NULL,
[tck_paychek_upload_amount_sb] [int] NULL,
[tck_filler] [varchar] (53) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[timestamp] [datetime] NULL
) ON [PRIMARY]
GO
GRANT DELETE ON  [dbo].[tck_fuelcard_transactions] TO [public]
GO
GRANT INSERT ON  [dbo].[tck_fuelcard_transactions] TO [public]
GO
GRANT REFERENCES ON  [dbo].[tck_fuelcard_transactions] TO [public]
GO
GRANT SELECT ON  [dbo].[tck_fuelcard_transactions] TO [public]
GO
GRANT UPDATE ON  [dbo].[tck_fuelcard_transactions] TO [public]
GO