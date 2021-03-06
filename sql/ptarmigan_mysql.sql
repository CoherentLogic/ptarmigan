
DROP TABLE IF EXISTS `administrators`;

CREATE TABLE `administrators` (
  `id` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `assignments`;

CREATE TABLE `assignments` (
  `id` varchar(255) NOT NULL,
  `task_id` varchar(255) NOT NULL,
  `employee_id` varchar(255) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `instructions` text NOT NULL,
  `address` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `zip` varchar(5) DEFAULT NULL,
  `latitude` varchar(255) DEFAULT NULL,
  `longitude` varchar(255) DEFAULT NULL,
  `location_preference` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0=address, 1=lat,lon',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `audits`;
CREATE TABLE `audits` (
  `id` varchar(255) NOT NULL,
  `table_name` varchar(255) NOT NULL,
  `table_id` varchar(255) NOT NULL,
  `change_order_number` varchar(255) NOT NULL DEFAULT '',
  `audit_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `employee_id` varchar(255) NOT NULL,
  `comment` text NOT NULL,
  `what_changed` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `billing_managers`;
CREATE TABLE `billing_managers` (
  `id` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `change_orders`;
CREATE TABLE `change_orders` (
  `id` varchar(255) NOT NULL,
  `change_order_number` varchar(255) NOT NULL,
  `extends_time` tinyint(4) NOT NULL DEFAULT '0',
  `extends_time_days` int(11) NOT NULL DEFAULT '0',
  `increases_budget` tinyint(4) NOT NULL DEFAULT '0',
  `increases_budget_dollars` float NOT NULL DEFAULT '0',
  `description` text NOT NULL,
  `document_id` varchar(255) NOT NULL DEFAULT '',
  `project_id` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `customers`;
CREATE TABLE `customers` (
  `id` varchar(255) NOT NULL,
  `company_name` varchar(255) NOT NULL,
  `poc` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `electronic_billing` tinyint(4) NOT NULL,
  `phone_number` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `document_types`;
CREATE TABLE `document_types` (
  `id` varchar(255) NOT NULL,
  `type_name` varchar(255) NOT NULL,
  `type_key` varchar(16) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `documents`;
CREATE TABLE `documents` (
  `id` varchar(255) NOT NULL,
  `path` varchar(255) NOT NULL,
  `document_name` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `document_number` varchar(255) DEFAULT NULL,
  `mime_type` varchar(50) NOT NULL,
  `filing_category` varchar(15) NOT NULL DEFAULT 'FILE',
  `filing_container` varchar(15) NOT NULL DEFAULT 'CABINET',
  `filing_division` varchar(50) NOT NULL DEFAULT ' ',
  `filing_material_type` varchar(10) NOT NULL DEFAULT 'PAGE',
  `filing_number` varchar(20) NOT NULL DEFAULT ' ',
  `filing_date` date NOT NULL,
  `thumbnail_url` varchar(255) NOT NULL,
  `document_revision` varchar(45) DEFAULT NULL,
  `section` varchar(5) DEFAULT NULL,
  `township` varchar(5) DEFAULT NULL,
  `range` varchar(5) DEFAULT NULL,
  `subdivision` varchar(255) DEFAULT NULL,
  `lot` varchar(45) DEFAULT NULL,
  `block` varchar(45) DEFAULT NULL,
  `usrs_sheet` varchar(45) DEFAULT NULL,
  `usrs_parcel` varchar(45) DEFAULT NULL,
  `address` varchar(45) DEFAULT NULL,
  `city` varchar(45) DEFAULT NULL,
  `state` varchar(45) DEFAULT NULL,
  `zip` varchar(45) DEFAULT NULL,
  `owner_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `employees`;
CREATE TABLE `employees` (
  `id` varchar(255) NOT NULL,
  `username` varchar(8) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `middle_initial` varchar(1) DEFAULT NULL,
  `first_name` varchar(50) NOT NULL,
  `hire_date` date DEFAULT NULL,
  `term_date` date DEFAULT NULL,
  `active` tinyint(4) NOT NULL DEFAULT '0',
  `email` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `honorific` varchar(10) NOT NULL,
  `suffix` varchar(10) DEFAULT NULL,
  `mail_address` varchar(255) NOT NULL,
  `mail_city` varchar(255) NOT NULL,
  `mail_state` varchar(255) NOT NULL,
  `mail_zip` varchar(255) NOT NULL,
  `work_phone` varchar(255) NOT NULL,
  `home_phone` varchar(255) DEFAULT NULL,
  `mobile_phone` varchar(255) NOT NULL,
  `gender` varchar(1) NOT NULL,
  `clocked_task_code_asgn_id` varchar(255) DEFAULT NULL,
  `clocked_timestamp` datetime DEFAULT NULL,
  `clocked_in` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `images`;
CREATE TABLE `images` (
  `ID` varchar(255) NOT NULL,
  `InputURL` varchar(255) NOT NULL,
  `Width` int(11) NOT NULL,
  `Height` int(11) NOT NULL,
  `LastAccess` datetime NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `object_access`;
CREATE TABLE `object_access` (
  `id` varchar(255) NOT NULL,
  `object_id` varchar(255) DEFAULT NULL,
  `user_id` varchar(255) DEFAULT NULL,
  `access_date` datetime DEFAULT NULL,
  `class_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `object_associations`;
CREATE TABLE `object_associations` (
  `id` varchar(255) NOT NULL,
  `source_object_id` varchar(255) NOT NULL,
  `target_object_id` varchar(255) NOT NULL,
  `association_name` varchar(255) NOT NULL,
  `source_object_class` varchar(255) NOT NULL,
  `target_object_class` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `object_audits`;
CREATE TABLE `object_audits` (
  `id` varchar(255) NOT NULL,
  `object_id` varchar(255) NOT NULL,
  `member_name` varchar(255) DEFAULT NULL,
  `original_value` varchar(255) DEFAULT NULL,
  `new_value` varchar(255) DEFAULT NULL,
  `edit_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `change_order_number` varchar(255) DEFAULT NULL,
  `comment` text NOT NULL,
  `employee_id` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `object_classes`;
CREATE TABLE `object_classes` (
  `id` varchar(255) NOT NULL,
  `class_name` varchar(50) NOT NULL,
  `component` varchar(255) NOT NULL,
  `top_level` tinyint(4) NOT NULL DEFAULT '0',
  `icon` varchar(50) NOT NULL,
  `opener` varchar(255) NOT NULL,
  `table_name` varchar(255) NOT NULL,
  `name_field` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

LOCK TABLES `object_classes` WRITE;
INSERT INTO `object_classes` VALUES ('OBJ_PROJECT','Project','ptarmigan.project',1,'project.png','{root_url}/project/edit_project.cfm?id={id}','projects','project_name'),('OBJ_PARCEL','Parcel','ptarmigan.parcel',1,'parcel.png','{root_url}/parcels/manage_parcel.cfm?id={id}','parcels','parcel_id'),('OBJ_DOCUMENT','Document','ptarmigan.document',1,'document.png','{root_url}/documents/manage_document.cfm?id={id}','documents','document_name'),('OBJ_EXPENSE','Expense','ptarmigan.expense',1,'expense.png','{root_url}/project/manage_expense.cfm?id={id}','project_expenses','recipient'),('OBJ_TASK','Task','ptarmigan.task',1,'task.png','{root_url}/project/manage_task.cfm?id={id}','tasks','task_name'),('OBJ_CUSTOMER','Customer','ptarmigan.customer',1,'customer.png','javascript:edit_customer(\'{root_url}\', \'{id}\');','customers','company_name'),('OBJ_EMPLOYEE','Employee','ptarmigan.employee',1,'employee.png','javascript:edit_employee(\'{root_url}\', \'{id}\');','employees','last_name'),('OBJ_COMPANY','Company','ptarmigan.company.company',0,'company.png','','',''),('OBJ_REPORT','Report','ptarmigan.report',1,'report.png','{root_url}/reports/report.cfm?id={id}','reports','report_name'),('OBJ_ASSOCIATION','Object Association','ptarmigan.object_association',0,'association.png','{root_url}/objects/manage_association.cfm?id={id}','',''),('OBJ_TASK_CONSTRAINT','Task Constraint','ptarmigan.task_constraint',0,'constraint.png','','','');
UNLOCK TABLES;

DROP TABLE IF EXISTS `objects`;
CREATE TABLE `objects` (
  `id` varchar(255) NOT NULL,
  `class_id` varchar(255) NOT NULL,
  `deleted` tinyint(4) NOT NULL DEFAULT '0',
  `parent_id` varchar(255) NOT NULL,
  `trashcan_handle` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `parcel_points`;
CREATE TABLE `parcel_points` (
  `parcel_id` varchar(255) NOT NULL,
  `latitude` double NOT NULL,
  `longitude` double NOT NULL,
  `id` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `parcels`;
CREATE TABLE `parcels` (
  `id` varchar(255) NOT NULL,
  `parcel_id` varchar(255) NOT NULL,
  `area_sq_ft` float NOT NULL,
  `area_sq_yd` float NOT NULL,
  `area_acres` float NOT NULL,
  `account_number` varchar(255) NOT NULL,
  `mailing_address` varchar(255) NOT NULL,
  `mailing_city` varchar(255) NOT NULL,
  `mailing_state` varchar(2) NOT NULL,
  `mailing_zip` varchar(5) NOT NULL,
  `subdivision` varchar(255) NOT NULL,
  `lot` varchar(255) NOT NULL,
  `block` varchar(255) NOT NULL,
  `physical_address` varchar(255) NOT NULL,
  `physical_city` varchar(255) NOT NULL,
  `physical_state` varchar(2) NOT NULL,
  `physical_zip` varchar(5) NOT NULL,
  `assessed_land_value` float NOT NULL,
  `assessed_building_value` float NOT NULL,
  `section` varchar(5) NOT NULL,
  `township` varchar(5) NOT NULL,
  `range` varchar(5) NOT NULL,
  `reception_number` varchar(50) NOT NULL,
  `owner_name` varchar(255) NOT NULL,
  `metes_and_bounds` text NOT NULL,
  `ground_survey` tinyint(4) NOT NULL DEFAULT '0',
  `center_latitude` double NOT NULL DEFAULT '0',
  `center_longitude` double NOT NULL DEFAULT '0',
  `center` point NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `pay_periods`;
CREATE TABLE `pay_periods` (
  `id` varchar(255) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `closed` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `project_expenses`;
CREATE TABLE `project_expenses` (
  `id` varchar(255) NOT NULL,
  `element_table` varchar(50) NOT NULL,
  `element_id` varchar(255) NOT NULL,
  `expense_date` date NOT NULL,
  `description` varchar(255) NOT NULL,
  `recipient` varchar(255) NOT NULL,
  `address` varchar(255) NOT NULL,
  `city` varchar(255) NOT NULL,
  `state` varchar(2) NOT NULL,
  `zip` varchar(5) NOT NULL,
  `poc` varchar(255) NOT NULL,
  `amount` float NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `project_managers`;
CREATE TABLE `project_managers` (
  `id` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `projects`;
CREATE TABLE `projects` (
  `id` varchar(255) NOT NULL,
  `project_number` varchar(12) NOT NULL,
  `project_name` varchar(255) NOT NULL,
  `instructions` text NOT NULL,
  `due_date` date NOT NULL,
  `customer_id` varchar(255) NOT NULL COMMENT 'FK to customers.id',
  `created_by` varchar(255) NOT NULL COMMENT 'FK to employees.id; indicates employee who created the record',
  `tax_rate` float NOT NULL,
  `start_date` date NOT NULL,
  `budget` float NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `report_columns`;
CREATE TABLE `report_columns` (
  `id` varchar(255) NOT NULL,
  `report_id` varchar(255) NOT NULL,
  `member_name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

LOCK TABLES `report_columns` WRITE;
INSERT INTO `report_columns` VALUES ('370A331E-B095-19E0-8A295D6A31EA368B','B448D94E-EEC9-0936-E29C5F2227C1753B','BUDGET'),('37D66B77-DEE9-6920-B885A98D1916B506','B448D94E-EEC9-0936-E29C5F2227C1753B','DUE_DATE'),('37D0F7A8-FF30-7073-9E51780FEE0A75C9','B448D94E-EEC9-0936-E29C5F2227C1753B','CREATED_BY'),('37D2DDE1-D092-0B32-CE5DC9A774703FF8','B448D94E-EEC9-0936-E29C5F2227C1753B','PROJECT_NUMBER'),('37D52BE6-E214-B3AC-0A0C95BFE26B6B2E','B448D94E-EEC9-0936-E29C5F2227C1753B','CUSTOMER_ID'),('5F8AE2B6-A91F-366B-CB9C6408602BEF7E','5F199C07-D038-777E-8A57E2725F9AF05D','TITLE'),('5F8B2FD5-A2EE-6D0B-D4733AEEF2F35BED','5F199C07-D038-777E-8A57E2725F9AF05D','HIRE_DATE'),('5F8BF662-9CE5-5EEF-725CE1E178C7BA50','5F199C07-D038-777E-8A57E2725F9AF05D','GENDER'),('6179463F-0B83-1EB5-AA9B80F54A32DF6D','616EAA42-A4DE-F68F-BE6D20F143CB74E3','TITLE'),('617F5558-CF21-442D-B0EE474F1C6BADDB','616EAA42-A4DE-F68F-BE6D20F143CB74E3','HIRE_DATE'),('61874166-AE5D-82EB-410901D1A746918C','6186EDF4-DEA6-264D-2A8CC1D1A204097B','TITLE'),('618766B4-B07B-0FF9-8ADB298CF7336CBF','6186EDF4-DEA6-264D-2A8CC1D1A204097B','GENDER'),('618E3A68-CE47-5F0C-896AF156ACBF76E7','6186EDF4-DEA6-264D-2A8CC1D1A204097B','HIRE_DATE'),('61CD3297-0D84-ABFB-6FB11878F1A1A49B','6186EDF4-DEA6-264D-2A8CC1D1A204097B','ACTIVE'),('65F3970C-C132-E003-A9A96449075F2F94','65EF4BF6-B3B0-6FAF-586E04FC879D07F7','DUE_DATE'),('623AA052-C51C-2C78-10F468611DFBA5CA','6239C9D1-D60A-415E-06DF06EE94C1A427','EMPLOYEE_ID'),('65F3584F-C3FC-ACB3-B652CD5E426A4A6D','65EF4BF6-B3B0-6FAF-586E04FC879D07F7','CUSTOMER_ID'),('6246CA19-EB3B-DA21-BCCC13C1F714A208','62465ABB-ED12-8986-9BEB007F5C8EEFE4','EMPLOYEE_ID'),('65F4613E-E76A-BA97-7B86675AFFE0F6DA','65EF4BF6-B3B0-6FAF-586E04FC879D07F7','START_DATE'),('67953244-B764-E7A1-7575B2A32A7A7A43','6239C9D1-D60A-415E-06DF06EE94C1A427','REPORT_KEY'),('67966435-FC5D-AFDF-4506A7949134C3D7','62465ABB-ED12-8986-9BEB007F5C8EEFE4','REPORT_KEY'),('6C5E35B5-AF52-05C2-4F53197E16BE177B','6C5C0D16-04A4-4E29-7B408F07331889F2','BUDGET'),('6C5E7AD7-FC4C-8F46-25556461E4C034F9','6C5C0D16-04A4-4E29-7B408F07331889F2','START_DATE'),('6C6382BA-978C-5747-00DA96A5F7E49544','6C5C0D16-04A4-4E29-7B408F07331889F2','END_DATE'),('6C99DD81-9BB2-8C2A-59E8D272DF9A2F64','6C5C0D16-04A4-4E29-7B408F07331889F2','PROJECT_ID'),('8A1CC8E2-C0B2-28EC-61AC1766F78F0F85','89EBD296-9F04-CC57-C8A0CD030BF089B9','FILING_DATE'),('8A1CE752-C838-701F-9F94503DB82614FF','89EBD296-9F04-CC57-C8A0CD030BF089B9','MIME_TYPE'),('8A1D0142-EE0C-7265-773915179546E2B2','89EBD296-9F04-CC57-C8A0CD030BF089B9','DESCRIPTION'),('8A1D168E-A83F-8C3F-DCCE861B67135894','89EBD296-9F04-CC57-C8A0CD030BF089B9','FILING_DIVISION'),('8A1D30A9-EAB1-AA95-2F8756DFFC879CC0','89EBD296-9F04-CC57-C8A0CD030BF089B9','FILING_NUMBER'),('8A1D619B-C450-39A9-5DFD032C69EE550C','89EBD296-9F04-CC57-C8A0CD030BF089B9','FILING_CATEGORY'),('8A1D739D-DF5E-6CD5-3DFCCFFB565E2C62','89EBD296-9F04-CC57-C8A0CD030BF089B9','FILING_MATERIAL_TYPE'),('8A1D8F29-B9CA-4D95-49DD37D5E38ECDE3','89EBD296-9F04-CC57-C8A0CD030BF089B9','FILING_CONTAINER'),('8A1DBC81-BA35-96F1-F8C21C869CAACBFA','89EBD296-9F04-CC57-C8A0CD030BF089B9','DOCUMENT_NUMBER'),('8E163F48-A25A-B80D-9D63BD06ADD280DE','8E141BE2-E110-4DED-0F6D4C1165E5E8F6','PARCEL_ID'),('8E16E09F-DA04-BA59-7B403D07198D9F02','8E141BE2-E110-4DED-0F6D4C1165E5E8F6','LOT'),('8E171B28-0CC4-D218-FCDA268032496145','8E141BE2-E110-4DED-0F6D4C1165E5E8F6','BLOCK'),('8E176945-D8FF-C282-9F19F7F296743F81','8E141BE2-E110-4DED-0F6D4C1165E5E8F6','SUBDIVISION'),('8E17BAF1-C4DF-4DB2-86B3D1E23E372057','8E141BE2-E110-4DED-0F6D4C1165E5E8F6','OWNER_NAME'),('8E18CB7B-F7C6-7E56-B32292FEB0CF33B9','8E141BE2-E110-4DED-0F6D4C1165E5E8F6','PHYSICAL_ADDRESS'),('8E191A28-905C-1A7F-32ADB3680C107FA5','8E141BE2-E110-4DED-0F6D4C1165E5E8F6','ACCOUNT_NUMBER'),('942B4946-E3FF-FAA6-12F5B272D1DC8428','94299E5A-00A6-EA98-9DC75173A37F643F','CHANGE_ORDER_NUMBER'),('942B5E28-FBC3-2058-F3E81BD77B3BAB2D','94299E5A-00A6-EA98-9DC75173A37F643F','AUDIT_DATE'),('942B9DCE-9208-5EDB-89DDF7D55235D261','94299E5A-00A6-EA98-9DC75173A37F643F','COMMENT'),('942BAC35-A8F8-E19C-9583E99F5F2BB611','94299E5A-00A6-EA98-9DC75173A37F643F','WHAT_CHANGED'),('942BBBFF-B296-AF2C-624FD8481523B970','94299E5A-00A6-EA98-9DC75173A37F643F','EMPLOYEE_ID'),('943970B9-D7D1-B3DE-17ABF1C1DB782048','94383DA3-E906-592E-C6ADF97007B3AB6E','AMOUNT'),('94394F2E-989A-46BC-69D465716E303EB6','94383DA3-E906-592E-C6ADF97007B3AB6E','RECIPIENT'),('9439B4BD-CCC1-5579-2677C7C726FC23B3','94383DA3-E906-592E-C6ADF97007B3AB6E','EXPENSE_DATE'),('9439F7EA-9227-3EAF-8B175CFC55411D28','94383DA3-E906-592E-C6ADF97007B3AB6E','POC'),('943A25EB-F4D3-4551-B50CB957AE68D1BF','94383DA3-E906-592E-C6ADF97007B3AB6E','DESCRIPTION'),('1E280D5C-9802-4776-B42D238E6133222E','A5CBFAC3-9F9B-4746-9676F188ED08D922','DOCUMENT_NAME');
UNLOCK TABLES;

DROP TABLE IF EXISTS `report_criteria`;
CREATE TABLE `report_criteria` (
  `id` varchar(255) NOT NULL,
  `report_id` varchar(255) NOT NULL,
  `member_name` varchar(255) NOT NULL,
  `operator` varchar(8) NOT NULL,
  `literal_a` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

LOCK TABLES `report_criteria` WRITE;
INSERT INTO `report_criteria` VALUES ('B448FB31-C539-B727-576AD1242C7B6163','B448D94E-EEC9-0936-E29C5F2227C1753B','CREATED_BY','=','{currentUser()}'),('5F82507B-0BBE-77B8-28AAE7BDF9C6298F','5F199C07-D038-777E-8A57E2725F9AF05D','HIRE_DATE','>','{startOfYear()}'),('5F845B38-A6BE-6907-77B112C4ED1BFE73','5F199C07-D038-777E-8A57E2725F9AF05D','HIRE_DATE','<','{endOfYear()}'),('6172F464-C362-5A03-57995B9DE0B63696','616EAA42-A4DE-F68F-BE6D20F143CB74E3','HIRE_DATE','>','{startOfMonth()}'),('61774832-9D27-16C6-31EFA1366EEDF0DC','616EAA42-A4DE-F68F-BE6D20F143CB74E3','HIRE_DATE','<','{endOfMonth()}'),('61898AAA-9795-31F7-65D088D5E0AB9DA7','6186EDF4-DEA6-264D-2A8CC1D1A204097B','HIRE_DATE','>','{startOfWeek()}'),('618B0AEE-E97C-1527-494988273181B828','6186EDF4-DEA6-264D-2A8CC1D1A204097B','HIRE_DATE','<','{endOfWeek()}'),('859648D2-F905-B935-BD8732EAA014E463','6239C9D1-D60A-415E-06DF06EE94C1A427','SYSTEM_REPORT','=','1'),('6247A7CE-EBDD-3B97-355C7D5D1862F79C','62465ABB-ED12-8986-9BEB007F5C8EEFE4','SYSTEM_REPORT','=','0'),('62493152-A594-7079-F3106CE8D991EA68','62465ABB-ED12-8986-9BEB007F5C8EEFE4','EMPLOYEE_ID','=','{currentUser()}'),('6C65F185-B11E-1D1C-1145629744780170','6C5C0D16-04A4-4E29-7B408F07331889F2','START_DATE','>','{startOfMonth()}'),('6C67C5D1-CF5E-5B85-46BD982390EF6588','6C5C0D16-04A4-4E29-7B408F07331889F2','START_DATE','<','{endOfMonth()}'),('8E1AE422-AA26-7E93-2B223724906749A8','8E141BE2-E110-4DED-0F6D4C1165E5E8F6','PHYSICAL_CITY','[','LAS CRUCES'),('1CA11957-85B8-4FEC-BD0953B6FF480D08','D85E2A00-58C8-4616-A49C8849517B8FAE','FILING_DATE','>','{startOfYear}'),('402A4D52-47FA-40BB-9AA374409FD23E97','D85E2A00-58C8-4616-A49C8849517B8FAE','FILING_DIVISION','<','{endOfYear}');
UNLOCK TABLES;

DROP TABLE IF EXISTS `reports`;
CREATE TABLE `reports` (
  `id` varchar(255) NOT NULL,
  `report_name` varchar(255) NOT NULL,
  `class_id` varchar(255) NOT NULL,
  `system_report` tinyint(4) NOT NULL,
  `employee_id` varchar(255) NOT NULL,
  `report_key` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

LOCK TABLES `reports` WRITE;
INSERT INTO `reports` VALUES ('B448D94E-EEC9-0936-E29C5F2227C1753B','My Projects','OBJ_PROJECT',1,'EE760207-FD54-269C-C9DCDBCF4949366D','MYPROJECTS'),('5F199C07-D038-777E-8A57E2725F9AF05D','New Hires This Year','OBJ_EMPLOYEE',1,'EE760207-FD54-269C-C9DCDBCF4949366D','HIRESYEAR'),('616EAA42-A4DE-F68F-BE6D20F143CB74E3','New Hires This Month','OBJ_EMPLOYEE',1,'EE760207-FD54-269C-C9DCDBCF4949366D','HIRESMONTH'),('6186EDF4-DEA6-264D-2A8CC1D1A204097B','New Hires This Week','OBJ_EMPLOYEE',1,'EE760207-FD54-269C-C9DCDBCF4949366D','HIRESWEEK'),('6239C9D1-D60A-415E-06DF06EE94C1A427','Built-In Reports','OBJ_REPORT',1,'EE760207-FD54-269C-C9DCDBCF4949366D','SYSREPT'),('62465ABB-ED12-8986-9BEB007F5C8EEFE4','My Reports','OBJ_REPORT',1,'EE760207-FD54-269C-C9DCDBCF4949366D','MYREPORTS'),('65E8C829-9E65-41F4-B0A8E5D13C8D26D3','All Projects','OBJ_PROJECT',1,'EE760207-FD54-269C-C9DCDBCF4949366D','ALLPROJECTS'),('65EF4BF6-B3B0-6FAF-586E04FC879D07F7','All Projects','OBJ_PROJECT',1,'EE760207-FD54-269C-C9DCDBCF4949366D',''),('6C5C0D16-04A4-4E29-7B408F07331889F2','Tasks Starting This Month','OBJ_MILESTONE',1,'EE760207-FD54-269C-C9DCDBCF4949366D','TASKSMO'),('89EBD296-9F04-CC57-C8A0CD030BF089B9','Test Doc Report','OBJ_DOCUMENT',0,'EE760207-FD54-269C-C9DCDBCF4949366D','TESTDOC'),('8E141BE2-E110-4DED-0F6D4C1165E5E8F6','Parcels in Las Cruces','OBJ_PARCEL',1,'EE760207-FD54-269C-C9DCDBCF4949366D','PARCLC'),('94299E5A-00A6-EA98-9DC75173A37F643F','All Audits','OBJ_AUDIT',1,'EE760207-FD54-269C-C9DCDBCF4949366D','AUDITALL'),('94383DA3-E906-592E-C6ADF97007B3AB6E','All Expenses','OBJ_EXPENSE',1,'EE760207-FD54-269C-C9DCDBCF4949366D','EXPENSEALL'),('3A8225CD-06DF-31E8-E755029C0972356E','All Object Associations','OBJ_ASSOCIATION',1,'EE760207-FD54-269C-C9DCDBCF4949366D','ALLOBJASSOC'),('A5CBFAC3-9F9B-4746-9676F188ED08D922','All Documents','OBJ_DOCUMENT',0,'EE760207-FD54-269C-C9DCDBCF4949366D','ALLDOCS'),('D85E2A00-58C8-4616-A49C8849517B8FAE','All Documents filed this year','OBJ_DOCUMENT',0,'EE760207-FD54-269C-C9DCDBCF4949366D','YEARDOCS');
UNLOCK TABLES;

DROP TABLE IF EXISTS `task_code_assignments`;
CREATE TABLE `task_code_assignments` (
  `id` varchar(255) NOT NULL,
  `task_code_id` varchar(255) NOT NULL,
  `assignment_id` varchar(255) NOT NULL,
  `rate` float NOT NULL DEFAULT '0',
  `billable` tinyint(4) NOT NULL DEFAULT '1',
  `employee_rate` float NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `task_codes`;
CREATE TABLE `task_codes` (
  `id` varchar(255) NOT NULL,
  `task_code` varchar(10) NOT NULL,
  `task_name` varchar(255) NOT NULL,
  `unit_type` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `task_constraints`;
CREATE TABLE `task_constraints` (
  `id` varchar(255) NOT NULL,
  `constraint_name` varchar(60) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

LOCK TABLES `task_constraints` WRITE;
INSERT INTO `task_constraints` VALUES ('SNLT','Start no later than'),('SNET','Start no earlier than'),('MS','Must start on'),('MF','Must finish on'),('FNLT','Finish no later than'),('FNET','Finish no earlier than'),('SALAP','Start as late as possible'),('SASAP','Start as soon as possible');
UNLOCK TABLES;


DROP TABLE IF EXISTS `task_dependencies`;
CREATE TABLE `task_dependencies` (
  `id` varchar(255) NOT NULL,
  `successor_id` varchar(255) NOT NULL,
  `predecessor_id` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `tasks`;
CREATE TABLE `tasks` (
  `id` varchar(255) NOT NULL,
  `project_id` varchar(255) NOT NULL,
  `task_name` varchar(255) NOT NULL,
  `description` text,
  `completed` tinyint(4) NOT NULL DEFAULT '0',
  `ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `budget` float NOT NULL,
  `color` varchar(30) NOT NULL DEFAULT 'blue',
  `percent_complete` int(11) NOT NULL DEFAULT '0',
  `task_group` varchar(255) NOT NULL,
  `duration` int(11) NOT NULL,
  `constraint_id` varchar(255) NOT NULL,
  `deadline` date NOT NULL,
  `constraint_date` date NOT NULL,
  `scheduled` tinyint(4) NOT NULL,
  `earliest_start` int(11) NOT NULL DEFAULT '0',
  `earliest_end` int(11) NOT NULL DEFAULT '0',
  `latest_start` int(11) NOT NULL DEFAULT '0',
  `latest_end` int(11) NOT NULL DEFAULT '0',
  `critical` tinyint(4) NOT NULL,
  `start` tinyint(4) NOT NULL DEFAULT '0',
  `stop` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `time_approvers`;
CREATE TABLE `time_approvers` (
  `id` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `time_entries`;
CREATE TABLE `time_entries` (
  `task_code_assignment_id` varchar(255) NOT NULL,
  `start_time` datetime NOT NULL,
  `end_time` datetime NOT NULL,
  `approved` tinyint(4) NOT NULL,
  `approver_id` varchar(255) NOT NULL,
  `id` varchar(255) NOT NULL,
  `employee_id` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
