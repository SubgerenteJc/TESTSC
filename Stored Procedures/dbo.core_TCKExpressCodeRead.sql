SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO

CREATE PROCEDURE [dbo].[core_TCKExpressCodeRead]
	@tck_expresscode_tck_account_number varchar (10),
	@tck_expresscode_tex_expresscodenumber varchar (20),
	@tck_expresscode_tex_currency varchar (6)
AS
	SELECT  tck_account_number as tck_expresscode_tck_account_number,
		tex_expresscodenumber as tck_expresscode_tex_expresscodenumber,
		tex_currency as tck_expresscode_tex_currency,
		tex_100000 as tck_expresscode_tex_100000,
		tex_100001 as tck_expresscode_tex_100001, 
		tex_100002 as tck_expresscode_tex_100002,
		tex_100003 as tck_expresscode_tex_100003,
		tex_100004 as tck_expresscode_tex_100004,
		tex_100005 as tck_expresscode_tex_100005,
		tex_100006 as tck_expresscode_tex_100006,
		tex_100007 as tck_expresscode_tex_100007,
		tex_100008 as tck_expresscode_tex_100008,
		tex_100009 as tck_expresscode_tex_100009,
		tex_10000 as tck_expresscode_tex_10000,
		tex_10001 as tck_expresscode_tex_10001,
		tex_10002 as tck_expresscode_tex_10002,
		tex_10003 as tck_expresscode_tex_10003,
		tex_10004 as tck_expresscode_tex_10004,
		tex_10005 as tck_expresscode_tex_10005,
		tex_10006 as tck_expresscode_tex_10006,
		tex_10007 as tck_expresscode_tex_10007,
		tex_10008 as tck_expresscode_tex_10008,
		tex_10009 as tck_expresscode_tex_10009,
		tex_1000 as tck_expresscode_tex_1000,
		tex_1001 as tck_expresscode_tex_1001,
		tex_1002 as tck_expresscode_tex_1002,
		tex_1003 as tck_expresscode_tex_1003,
		tex_1004 as tck_expresscode_tex_1004,
		tex_1005 as tck_expresscode_tex_1005,
		tex_1006 as tck_expresscode_tex_1006,
		tex_1007 as tck_expresscode_tex_1007,
		tex_1008 as tck_expresscode_tex_1008,
		tex_1009 as tck_expresscode_tex_1009,
		tex_100 as tck_expresscode_tex_100,
		tex_101 as tck_expresscode_tex_101,
		tex_102 as tck_expresscode_tex_102,
		tex_103 as tck_expresscode_tex_103,
		tex_104 as tck_expresscode_tex_104,
		tex_105 as tck_expresscode_tex_105,
		tex_106 as tck_expresscode_tex_106,
		tex_107 as tck_expresscode_tex_107,
		tex_108 as tck_expresscode_tex_108,
		tex_109 as tck_expresscode_tex_109,
		tex_10 as tck_expresscode_tex_10,
		tex_11 as tck_expresscode_tex_11,
		tex_12 as tck_expresscode_tex_12,
		tex_13 as tck_expresscode_tex_13,
		tex_14 as tck_expresscode_tex_14,
		tex_15 as tck_expresscode_tex_15,
		tex_16 as tck_expresscode_tex_16,
		tex_17 as tck_expresscode_tex_17,
		tex_18 as tck_expresscode_tex_18,
		tex_19 as tck_expresscode_tex_19,
		tex_0 as tck_expresscode_tex_0,
		tex_1 as tck_expresscode_tex_1,
		tex_2 as tck_expresscode_tex_2,
		tex_3 as tck_expresscode_tex_3,
		tex_4 as tck_expresscode_tex_4,
		tex_5 as tck_expresscode_tex_5,
		tex_6 as tck_expresscode_tex_6,
		tex_7 as tck_expresscode_tex_7,
		tex_8 as tck_expresscode_tex_8,
		tex_9 as tck_expresscode_tex_9,
		tex_s25 as tck_expresscode_tex_s25,
		tex_s50 as tck_expresscode_tex_s50,
		tex_s75 as tck_expresscode_tex_s75,
		tex_s100 as tck_expresscode_tex_s100,
		tex_s125 as tck_expresscode_tex_s125,
		tex_s150 as tck_expresscode_tex_s150,
		tex_s200 as tck_expresscode_tex_s200,
		tex_s300 as tck_expresscode_tex_s300,
		tex_s400 as tck_expresscode_tex_s400,
		tex_s500 as tck_expresscode_tex_s500,
		tex_s700 as tck_expresscode_tex_s700,
		tex_s900 as tck_expresscode_tex_s900,
		tex_expire_date as tck_expresscode_tex_expire_date,
		tex_initial_date as tck_expresscode_tex_initial_date,
		tex_status as tck_expresscode_tex_status
	FROM [tck_expresscode]
	WHERE 	tck_account_number = @tck_expresscode_tck_account_number
	AND	tex_expresscodenumber = @tck_expresscode_tex_expresscodenumber
	AND	tex_currency = @tck_expresscode_tex_currency

GO
GRANT EXECUTE ON  [dbo].[core_TCKExpressCodeRead] TO [public]
GO
