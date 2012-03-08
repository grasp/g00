CREATE TABLE `cargo_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `ancestry` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ancestry_depth` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_cargo_categories_on_ancestry` (`ancestry`)
) ENGINE=InnoDB AUTO_INCREMENT=268 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `cargos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cate_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `package_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `big_category` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cargo_weight` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cargo_zuhuo` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cargo_bulk` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `send_date` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comments` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fcity_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tcity_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `company_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fcity_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tcity_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fcity_id` int(11) DEFAULT NULL,
  `tcity_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `contact_person_id` int(11) DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL,
  `stock_cargo_id` int(11) DEFAULT NULL,
  `pingjia_id` int(11) DEFAULT NULL,
  `cstatistic_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `cities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `ancestry` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ancestry_depth` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_cities_on_ancestry` (`ancestry`)
) ENGINE=InnoDB AUTO_INCREMENT=3345 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `companies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `about` text COLLATE utf8_unicode_ci,
  `self_che` int(11) DEFAULT NULL,
  `signed_che` int(11) DEFAULT NULL,
  `num_employ` int(11) DEFAULT NULL,
  `contact_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `city_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `city_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `city_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fix_phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mobile_phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `company_license_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `contact_people` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `QQ` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fix_phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mobile_phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `website` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `group` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `contact_group_id` int(11) DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL,
  `driver_id` int(11) DEFAULT NULL,
  `custmer_id` int(11) DEFAULT NULL,
  `vendor_id` int(11) DEFAULT NULL,
  `truck_owner_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `inqueries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `price` int(11) DEFAULT NULL,
  `comments` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `habit_word` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fcity_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tcity_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cate_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cargo_id` int(11) DEFAULT NULL,
  `paizhao` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `truck_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `user_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `userb_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `userb_id` int(11) DEFAULT NULL,
  `companyb_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `companyb_id` int(11) DEFAULT NULL,
  `company_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL,
  `ismailed` int(11) DEFAULT NULL,
  `isaccepted` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `line_ads` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `line` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fcity_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tcity_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `company_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `one_word` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `contact_phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL,
  `lstatistic_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `package_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `ancestry` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ancestry_depth` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_package_categories_on_ancestry` (`ancestry`)
) ENGINE=InnoDB AUTO_INCREMENT=90 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `quotes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `price` int(11) DEFAULT NULL,
  `comments` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `habit_word` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fcity_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tcity_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cate_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cargo_id` int(11) DEFAULT NULL,
  `paizhao` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `truck_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `user_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `userb_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `userb_id` int(11) DEFAULT NULL,
  `companyb_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `companyb_id` int(11) DEFAULT NULL,
  `company_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL,
  `ismailed` int(11) DEFAULT NULL,
  `isaccepted` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `searches` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fcity_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fcity_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tcity_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tcity_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `stype` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `stock_cargos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `big_category` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cate_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cate_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `custermer_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `package_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `package_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `custermer_package` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cargo_property` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `stock_status` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `company_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ku_weight` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ku_bulk` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sent_weight` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sent_bulk` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cate_id` int(11) DEFAULT NULL,
  `package_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL,
  `cangku_id` int(11) DEFAULT NULL,
  `scstatistic_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `stock_trucks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `paizhao` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `dun_wei` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `che_length` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `truck_usage` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `truck_shape` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `truck_gps` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `driver_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `driver_phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `car_phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `truck_pinpai` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `truck_xinghao` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `truck_year` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `company_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `contact_person_id` int(11) DEFAULT NULL,
  `truck_license_id` int(11) DEFAULT NULL,
  `truck_owner_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `trucks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `paizhao` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `dunwei` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `length` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `shape` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `usage` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `send_date` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comments` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `huicheng` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fcity_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tcity_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `company_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `driver_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `driver_phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `car_phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fcity_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tcity_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `contact_person_id` int(11) DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL,
  `truck_pingjia_id` int(11) DEFAULT NULL,
  `truck_status_id` int(11) DEFAULT NULL,
  `truck_statistic_id` int(11) DEFAULT NULL,
  `stock_truck_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `nick_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `hashed_password` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `salt` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `activate` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL,
  `contact_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO schema_migrations (version) VALUES ('20101023163730');

INSERT INTO schema_migrations (version) VALUES ('20101023163808');

INSERT INTO schema_migrations (version) VALUES ('20101023163920');

INSERT INTO schema_migrations (version) VALUES ('20101023164110');

INSERT INTO schema_migrations (version) VALUES ('20101023164137');

INSERT INTO schema_migrations (version) VALUES ('20101023164436');

INSERT INTO schema_migrations (version) VALUES ('20101023164838');

INSERT INTO schema_migrations (version) VALUES ('20101023165147');

INSERT INTO schema_migrations (version) VALUES ('20101023165425');

INSERT INTO schema_migrations (version) VALUES ('20101023165740');

INSERT INTO schema_migrations (version) VALUES ('20101023170328');

INSERT INTO schema_migrations (version) VALUES ('20101023170432');

INSERT INTO schema_migrations (version) VALUES ('20101023170914');

INSERT INTO schema_migrations (version) VALUES ('20101031114934');

INSERT INTO schema_migrations (version) VALUES ('20101105142241');

INSERT INTO schema_migrations (version) VALUES ('20101110115434');

INSERT INTO schema_migrations (version) VALUES ('20101110135239');