/*
 Navicat Premium Dump SQL

 Source Server         : 123456
 Source Server Type    : MySQL
 Source Server Version : 80100 (8.1.0)
 Source Host           : localhost:3306
 Source Schema         : todo_db

 Target Server Type    : MySQL
 Target Server Version : 80100 (8.1.0)
 File Encoding         : 65001

 Date: 10/12/2024 20:48:57
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for accounts_historicaluser
-- ----------------------------
DROP TABLE IF EXISTS `accounts_historicaluser`;
CREATE TABLE `accounts_historicaluser`  (
  `id` bigint NOT NULL,
  `password` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `last_login` datetime(6) NULL DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `first_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `last_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `email` varchar(254) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `wechat_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `avatar` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `is_email_verified` tinyint(1) NOT NULL,
  `last_login_ip` char(39) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `history_id` int NOT NULL AUTO_INCREMENT,
  `history_date` datetime(6) NOT NULL,
  `history_change_reason` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `history_type` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `history_user_id` bigint NULL DEFAULT NULL,
  PRIMARY KEY (`history_id`) USING BTREE,
  INDEX `accounts_historicalu_history_user_id_db1b2c5f_fk_accounts_`(`history_user_id` ASC) USING BTREE,
  INDEX `accounts_historicaluser_id_d7601895`(`id` ASC) USING BTREE,
  INDEX `accounts_historicaluser_username_e37d9ea8`(`username` ASC) USING BTREE,
  INDEX `accounts_historicaluser_phone_d2e8519d`(`phone` ASC) USING BTREE,
  INDEX `accounts_historicaluser_wechat_id_07f1b891`(`wechat_id` ASC) USING BTREE,
  INDEX `accounts_historicaluser_history_date_94c91976`(`history_date` ASC) USING BTREE,
  CONSTRAINT `accounts_historicalu_history_user_id_db1b2c5f_fk_accounts_` FOREIGN KEY (`history_user_id`) REFERENCES `accounts_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 40 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of accounts_historicaluser
-- ----------------------------
INSERT INTO `accounts_historicaluser` VALUES (1, 'pbkdf2_sha256$720000$i1UTqPwlK9OTCjnHjhwHxr$QQ09Nar625Jq+0iC7vX607ncOyDElcOuu2MoiZ4Wl6w=', NULL, 0, 'fx0883', '', '', 'fx0883@qq.com', 0, 1, '2024-12-08 15:58:02.147338', NULL, NULL, '', 0, NULL, '2024-12-08 15:58:02.412728', '2024-12-08 15:58:02.412728', 1, '2024-12-08 15:58:02.412728', NULL, '+', NULL);
INSERT INTO `accounts_historicaluser` VALUES (1, 'pbkdf2_sha256$720000$i1UTqPwlK9OTCjnHjhwHxr$QQ09Nar625Jq+0iC7vX607ncOyDElcOuu2MoiZ4Wl6w=', '2024-12-08 16:00:19.189109', 0, 'fx0883', '', '', 'fx0883@qq.com', 0, 1, '2024-12-08 15:58:02.147338', NULL, NULL, '', 0, NULL, '2024-12-08 15:58:02.412728', '2024-12-08 15:58:02.412728', 2, '2024-12-08 16:00:19.190116', NULL, '~', 1);
INSERT INTO `accounts_historicaluser` VALUES (1, 'pbkdf2_sha256$720000$i1UTqPwlK9OTCjnHjhwHxr$QQ09Nar625Jq+0iC7vX607ncOyDElcOuu2MoiZ4Wl6w=', '2024-12-08 16:00:46.670200', 0, 'fx0883', '', '', 'fx0883@qq.com', 0, 1, '2024-12-08 15:58:02.147338', NULL, NULL, '', 0, NULL, '2024-12-08 15:58:02.412728', '2024-12-08 15:58:02.412728', 3, '2024-12-08 16:00:46.673716', NULL, '~', 1);
INSERT INTO `accounts_historicaluser` VALUES (1, 'pbkdf2_sha256$720000$i1UTqPwlK9OTCjnHjhwHxr$QQ09Nar625Jq+0iC7vX607ncOyDElcOuu2MoiZ4Wl6w=', '2024-12-08 16:02:40.488785', 0, 'fx0883', '', '', 'fx0883@qq.com', 0, 1, '2024-12-08 15:58:02.147338', NULL, NULL, '', 0, NULL, '2024-12-08 15:58:02.412728', '2024-12-08 15:58:02.412728', 4, '2024-12-08 16:02:40.488785', NULL, '~', 1);
INSERT INTO `accounts_historicaluser` VALUES (1, 'pbkdf2_sha256$720000$i1UTqPwlK9OTCjnHjhwHxr$QQ09Nar625Jq+0iC7vX607ncOyDElcOuu2MoiZ4Wl6w=', '2024-12-09 02:58:16.264737', 0, 'fx0883', '', '', 'fx0883@qq.com', 0, 1, '2024-12-08 15:58:02.147338', NULL, NULL, '', 0, NULL, '2024-12-08 15:58:02.412728', '2024-12-08 15:58:02.412728', 5, '2024-12-09 02:58:16.266736', NULL, '~', 1);
INSERT INTO `accounts_historicaluser` VALUES (1, 'pbkdf2_sha256$720000$i1UTqPwlK9OTCjnHjhwHxr$QQ09Nar625Jq+0iC7vX607ncOyDElcOuu2MoiZ4Wl6w=', '2024-12-09 03:05:15.176246', 0, 'fx0883', '', '', 'fx0883@qq.com', 0, 1, '2024-12-08 15:58:02.147338', NULL, NULL, '', 0, NULL, '2024-12-08 15:58:02.412728', '2024-12-08 15:58:02.412728', 6, '2024-12-09 03:05:15.178856', NULL, '~', 1);
INSERT INTO `accounts_historicaluser` VALUES (1, 'pbkdf2_sha256$720000$i1UTqPwlK9OTCjnHjhwHxr$QQ09Nar625Jq+0iC7vX607ncOyDElcOuu2MoiZ4Wl6w=', '2024-12-09 03:10:51.068684', 0, 'fx0883', '', '', 'fx0883@qq.com', 0, 1, '2024-12-08 15:58:02.147338', NULL, NULL, '', 0, NULL, '2024-12-08 15:58:02.412728', '2024-12-08 15:58:02.412728', 7, '2024-12-09 03:10:51.078426', NULL, '~', 1);
INSERT INTO `accounts_historicaluser` VALUES (2, 'pbkdf2_sha256$720000$9Wi6vHS8F0kt7bJH9RBWLt$0M56ogXXJBkxnvN36iQWgFc+vuT4pVKSit+EbDucF2U=', NULL, 1, 'admin', '', '', 'admin@123.com', 1, 1, '2024-12-09 03:36:03.989563', NULL, NULL, '', 0, NULL, '2024-12-09 03:36:04.146217', '2024-12-09 03:36:04.146217', 8, '2024-12-09 03:36:04.148723', NULL, '+', NULL);
INSERT INTO `accounts_historicaluser` VALUES (2, 'pbkdf2_sha256$720000$9Wi6vHS8F0kt7bJH9RBWLt$0M56ogXXJBkxnvN36iQWgFc+vuT4pVKSit+EbDucF2U=', '2024-12-09 03:37:04.506469', 1, 'admin', '', '', 'admin@123.com', 1, 1, '2024-12-09 03:36:03.989563', NULL, NULL, '', 0, NULL, '2024-12-09 03:36:04.146217', '2024-12-09 03:36:04.146217', 9, '2024-12-09 03:37:04.508744', NULL, '~', 2);
INSERT INTO `accounts_historicaluser` VALUES (1, 'pbkdf2_sha256$720000$i1UTqPwlK9OTCjnHjhwHxr$QQ09Nar625Jq+0iC7vX607ncOyDElcOuu2MoiZ4Wl6w=', '2024-12-09 04:44:26.138388', 0, 'fx0883', '', '', 'fx0883@qq.com', 0, 1, '2024-12-08 15:58:02.147338', NULL, NULL, '', 0, NULL, '2024-12-08 15:58:02.412728', '2024-12-08 15:58:02.412728', 10, '2024-12-09 04:44:26.140269', NULL, '~', 1);
INSERT INTO `accounts_historicaluser` VALUES (1, 'pbkdf2_sha256$720000$i1UTqPwlK9OTCjnHjhwHxr$QQ09Nar625Jq+0iC7vX607ncOyDElcOuu2MoiZ4Wl6w=', '2024-12-09 04:47:13.300674', 0, 'fx0883', '', '', 'fx0883@qq.com', 0, 1, '2024-12-08 15:58:02.147338', NULL, NULL, '', 0, NULL, '2024-12-08 15:58:02.412728', '2024-12-08 15:58:02.412728', 11, '2024-12-09 04:47:13.304780', NULL, '~', 1);
INSERT INTO `accounts_historicaluser` VALUES (3, '', NULL, 0, 'johndoe', 'John', 'Doe', 'john@example.com', 0, 1, '2024-12-09 06:11:34.646312', NULL, NULL, '', 0, NULL, '2024-12-09 06:11:34.646312', '2024-12-09 06:11:34.646312', 12, '2024-12-09 06:11:34.654203', NULL, '+', 1);
INSERT INTO `accounts_historicaluser` VALUES (4, 'pbkdf2_sha256$720000$Zy0ZM58q3UEaoxexTRDGm6$VtGsqFxMA9rjCPRAvOCHjdJb4irC/QTxogaL8x3o3ig=', NULL, 0, 'johndoe', 'John', 'Doe', 'john@example.com', 0, 1, '2024-12-09 08:18:36.130906', NULL, NULL, '', 0, NULL, '2024-12-09 08:18:36.303508', '2024-12-09 08:18:36.303508', 13, '2024-12-09 08:18:36.305507', NULL, '+', 1);
INSERT INTO `accounts_historicaluser` VALUES (1, 'pbkdf2_sha256$720000$ZaOLZ4u2sHnX19IWre4jdU$hNAkPuho/whryFbrk+dz7q9fz0sC1XM25Pkv3q/643I=', '2024-12-09 04:47:13.300674', 0, 'fx0883', '', '', 'fx0883@qq.com', 0, 1, '2024-12-08 15:58:02.147338', NULL, NULL, '', 0, NULL, '2024-12-08 15:58:02.412728', '2024-12-09 12:15:35.325931', 14, '2024-12-09 12:15:35.327927', NULL, '~', NULL);
INSERT INTO `accounts_historicaluser` VALUES (1, 'pbkdf2_sha256$720000$uxmocJg9Km2K8su1OJ4KLF$mgT2KFTSiOsjAeAbmEyLaQVfaCRQoPPBJIAnDL2Idyw=', '2024-12-09 04:47:13.300674', 0, 'fx0883', '', '', 'fx0883@qq.com', 0, 1, '2024-12-08 15:58:02.147338', NULL, NULL, '', 0, NULL, '2024-12-08 15:58:02.412728', '2024-12-09 12:17:52.354775', 15, '2024-12-09 12:17:52.356776', NULL, '~', NULL);
INSERT INTO `accounts_historicaluser` VALUES (1, 'pbkdf2_sha256$720000$uxmocJg9Km2K8su1OJ4KLF$mgT2KFTSiOsjAeAbmEyLaQVfaCRQoPPBJIAnDL2Idyw=', '2024-12-09 12:29:18.136861', 0, 'fx0883', '', '', 'fx0883@qq.com', 0, 1, '2024-12-08 15:58:02.147338', NULL, NULL, '', 0, NULL, '2024-12-08 15:58:02.412728', '2024-12-09 12:17:52.354775', 16, '2024-12-09 12:29:18.138864', NULL, '~', NULL);
INSERT INTO `accounts_historicaluser` VALUES (4, 'pbkdf2_sha256$720000$Zy0ZM58q3UEaoxexTRDGm6$VtGsqFxMA9rjCPRAvOCHjdJb4irC/QTxogaL8x3o3ig=', '2024-12-09 12:42:17.004149', 0, 'johndoe', 'John', 'Doe', 'john@example.com', 0, 1, '2024-12-09 08:18:36.130906', NULL, NULL, '', 0, NULL, '2024-12-09 08:18:36.303508', '2024-12-09 08:18:36.303508', 17, '2024-12-09 12:42:17.006085', NULL, '~', 4);
INSERT INTO `accounts_historicaluser` VALUES (4, 'pbkdf2_sha256$720000$Zy0ZM58q3UEaoxexTRDGm6$VtGsqFxMA9rjCPRAvOCHjdJb4irC/QTxogaL8x3o3ig=', '2024-12-09 14:13:26.340656', 0, 'johndoe', 'John', 'Doe', 'john@example.com', 0, 1, '2024-12-09 08:18:36.130906', NULL, NULL, '', 0, NULL, '2024-12-09 08:18:36.303508', '2024-12-09 08:18:36.303508', 18, '2024-12-09 14:13:26.340656', NULL, '~', 4);
INSERT INTO `accounts_historicaluser` VALUES (1, 'pbkdf2_sha256$720000$uxmocJg9Km2K8su1OJ4KLF$mgT2KFTSiOsjAeAbmEyLaQVfaCRQoPPBJIAnDL2Idyw=', '2024-12-09 14:14:11.474065', 0, 'fx0883', '', '', 'fx0883@qq.com', 0, 1, '2024-12-08 15:58:02.147338', NULL, NULL, '', 0, NULL, '2024-12-08 15:58:02.412728', '2024-12-09 12:17:52.354775', 19, '2024-12-09 14:14:11.475575', NULL, '~', 1);
INSERT INTO `accounts_historicaluser` VALUES (4, 'pbkdf2_sha256$720000$Zy0ZM58q3UEaoxexTRDGm6$VtGsqFxMA9rjCPRAvOCHjdJb4irC/QTxogaL8x3o3ig=', '2024-12-09 14:24:08.916255', 0, 'johndoe', 'John', 'Doe', 'john@example.com', 0, 1, '2024-12-09 08:18:36.130906', NULL, NULL, '', 0, NULL, '2024-12-09 08:18:36.303508', '2024-12-09 08:18:36.303508', 20, '2024-12-09 14:24:08.918271', NULL, '~', 4);
INSERT INTO `accounts_historicaluser` VALUES (1, 'pbkdf2_sha256$720000$uxmocJg9Km2K8su1OJ4KLF$mgT2KFTSiOsjAeAbmEyLaQVfaCRQoPPBJIAnDL2Idyw=', '2024-12-09 14:30:25.745939', 0, 'fx0883', '', '', 'fx0883@qq.com', 0, 1, '2024-12-08 15:58:02.147338', NULL, NULL, '', 0, NULL, '2024-12-08 15:58:02.412728', '2024-12-09 12:17:52.354775', 21, '2024-12-09 14:30:25.745939', NULL, '~', 1);
INSERT INTO `accounts_historicaluser` VALUES (1, 'pbkdf2_sha256$720000$uxmocJg9Km2K8su1OJ4KLF$mgT2KFTSiOsjAeAbmEyLaQVfaCRQoPPBJIAnDL2Idyw=', '2024-12-09 14:35:58.144134', 0, 'fx0883', '', '', 'fx0883@qq.com', 0, 1, '2024-12-08 15:58:02.147338', NULL, NULL, '', 0, NULL, '2024-12-08 15:58:02.412728', '2024-12-09 12:17:52.354775', 22, '2024-12-09 14:35:58.144134', NULL, '~', 1);
INSERT INTO `accounts_historicaluser` VALUES (1, 'pbkdf2_sha256$720000$uxmocJg9Km2K8su1OJ4KLF$mgT2KFTSiOsjAeAbmEyLaQVfaCRQoPPBJIAnDL2Idyw=', '2024-12-09 14:42:03.478247', 0, 'fx0883', '', '', 'fx0883@qq.com', 0, 1, '2024-12-08 15:58:02.147338', NULL, NULL, '', 0, NULL, '2024-12-08 15:58:02.412728', '2024-12-09 12:17:52.354775', 23, '2024-12-09 14:42:03.478247', NULL, '~', 1);
INSERT INTO `accounts_historicaluser` VALUES (5, 'pbkdf2_sha256$720000$bW47acK4xiv2Rlqp3DQz47$c2bwi67J13kHnBeDFsOhRv547EKbGGKS1slfEdCrggY=', NULL, 0, 'fx123', '', '', '', 0, 1, '2024-12-09 15:16:36.081430', NULL, NULL, '', 0, NULL, '2024-12-09 15:16:36.342307', '2024-12-09 15:16:36.342307', 24, '2024-12-09 15:16:36.345330', NULL, '+', 1);
INSERT INTO `accounts_historicaluser` VALUES (5, 'pbkdf2_sha256$720000$bW47acK4xiv2Rlqp3DQz47$c2bwi67J13kHnBeDFsOhRv547EKbGGKS1slfEdCrggY=', '2024-12-09 15:16:46.199019', 0, 'fx123', '', '', '', 0, 1, '2024-12-09 15:16:36.081430', NULL, NULL, '', 0, NULL, '2024-12-09 15:16:36.342307', '2024-12-09 15:16:36.342307', 25, '2024-12-09 15:16:46.201472', NULL, '~', 5);
INSERT INTO `accounts_historicaluser` VALUES (5, 'pbkdf2_sha256$720000$bW47acK4xiv2Rlqp3DQz47$c2bwi67J13kHnBeDFsOhRv547EKbGGKS1slfEdCrggY=', '2024-12-09 15:21:31.166330', 0, 'fx123', '', '', '', 0, 1, '2024-12-09 15:16:36.081430', NULL, NULL, '', 0, NULL, '2024-12-09 15:16:36.342307', '2024-12-09 15:16:36.342307', 26, '2024-12-09 15:21:31.166834', NULL, '~', 5);
INSERT INTO `accounts_historicaluser` VALUES (5, 'pbkdf2_sha256$720000$bW47acK4xiv2Rlqp3DQz47$c2bwi67J13kHnBeDFsOhRv547EKbGGKS1slfEdCrggY=', '2024-12-09 15:24:50.197887', 0, 'fx123', '', '', '', 0, 1, '2024-12-09 15:16:36.081430', NULL, NULL, '', 0, NULL, '2024-12-09 15:16:36.342307', '2024-12-09 15:16:36.342307', 27, '2024-12-09 15:24:50.198898', NULL, '~', 5);
INSERT INTO `accounts_historicaluser` VALUES (1, 'pbkdf2_sha256$720000$uxmocJg9Km2K8su1OJ4KLF$mgT2KFTSiOsjAeAbmEyLaQVfaCRQoPPBJIAnDL2Idyw=', '2024-12-10 02:52:57.304140', 0, 'fx0883', '', '', 'fx0883@qq.com', 0, 1, '2024-12-08 15:58:02.147338', NULL, NULL, '', 0, NULL, '2024-12-08 15:58:02.412728', '2024-12-09 12:17:52.354775', 28, '2024-12-10 02:52:57.306804', NULL, '~', 1);
INSERT INTO `accounts_historicaluser` VALUES (1, 'pbkdf2_sha256$720000$uxmocJg9Km2K8su1OJ4KLF$mgT2KFTSiOsjAeAbmEyLaQVfaCRQoPPBJIAnDL2Idyw=', '2024-12-10 03:43:56.728609', 0, 'fx0883', '', '', 'fx0883@qq.com', 0, 1, '2024-12-08 15:58:02.147338', NULL, NULL, '', 0, NULL, '2024-12-08 15:58:02.412728', '2024-12-09 12:17:52.354775', 29, '2024-12-10 03:43:56.730124', NULL, '~', 1);
INSERT INTO `accounts_historicaluser` VALUES (4, 'pbkdf2_sha256$720000$Zy0ZM58q3UEaoxexTRDGm6$VtGsqFxMA9rjCPRAvOCHjdJb4irC/QTxogaL8x3o3ig=', '2024-12-10 06:17:04.553083', 0, 'johndoe', 'John', 'Doe', 'john@example.com', 0, 1, '2024-12-09 08:18:36.130906', NULL, NULL, '', 0, NULL, '2024-12-09 08:18:36.303508', '2024-12-09 08:18:36.303508', 30, '2024-12-10 06:17:04.556082', NULL, '~', 4);
INSERT INTO `accounts_historicaluser` VALUES (4, 'pbkdf2_sha256$720000$Zy0ZM58q3UEaoxexTRDGm6$VtGsqFxMA9rjCPRAvOCHjdJb4irC/QTxogaL8x3o3ig=', '2024-12-10 06:17:37.576489', 0, 'johndoe', 'John', 'Doe', 'john@example.com', 0, 1, '2024-12-09 08:18:36.130906', NULL, NULL, '', 0, NULL, '2024-12-09 08:18:36.303508', '2024-12-09 08:18:36.303508', 31, '2024-12-10 06:17:37.578106', NULL, '~', 4);
INSERT INTO `accounts_historicaluser` VALUES (1, 'pbkdf2_sha256$720000$uxmocJg9Km2K8su1OJ4KLF$mgT2KFTSiOsjAeAbmEyLaQVfaCRQoPPBJIAnDL2Idyw=', '2024-12-10 06:33:39.175522', 0, 'fx0883', '', '', 'fx0883@qq.com', 0, 1, '2024-12-08 15:58:02.147338', NULL, NULL, '', 0, NULL, '2024-12-08 15:58:02.412728', '2024-12-09 12:17:52.354775', 32, '2024-12-10 06:33:39.176549', NULL, '~', 1);
INSERT INTO `accounts_historicaluser` VALUES (1, 'pbkdf2_sha256$720000$uxmocJg9Km2K8su1OJ4KLF$mgT2KFTSiOsjAeAbmEyLaQVfaCRQoPPBJIAnDL2Idyw=', '2024-12-10 06:35:13.129438', 0, 'fx0883', '', '', 'fx0883@qq.com', 0, 1, '2024-12-08 15:58:02.147338', NULL, NULL, '', 0, NULL, '2024-12-08 15:58:02.412728', '2024-12-09 12:17:52.354775', 33, '2024-12-10 06:35:13.130956', NULL, '~', 1);
INSERT INTO `accounts_historicaluser` VALUES (4, 'pbkdf2_sha256$720000$Zy0ZM58q3UEaoxexTRDGm6$VtGsqFxMA9rjCPRAvOCHjdJb4irC/QTxogaL8x3o3ig=', '2024-12-10 06:36:34.568279', 0, 'johndoe', 'John', 'Doe', 'john@example.com', 0, 1, '2024-12-09 08:18:36.130906', NULL, NULL, '', 0, NULL, '2024-12-09 08:18:36.303508', '2024-12-09 08:18:36.303508', 34, '2024-12-10 06:36:34.572480', NULL, '~', 4);
INSERT INTO `accounts_historicaluser` VALUES (1, 'pbkdf2_sha256$720000$uxmocJg9Km2K8su1OJ4KLF$mgT2KFTSiOsjAeAbmEyLaQVfaCRQoPPBJIAnDL2Idyw=', '2024-12-10 06:37:50.507041', 0, 'fx0883', '', '', 'fx0883@qq.com', 0, 1, '2024-12-08 15:58:02.147338', NULL, NULL, '', 0, NULL, '2024-12-08 15:58:02.412728', '2024-12-09 12:17:52.354775', 35, '2024-12-10 06:37:50.508401', NULL, '~', 1);
INSERT INTO `accounts_historicaluser` VALUES (1, 'pbkdf2_sha256$720000$uxmocJg9Km2K8su1OJ4KLF$mgT2KFTSiOsjAeAbmEyLaQVfaCRQoPPBJIAnDL2Idyw=', '2024-12-10 12:18:03.416659', 0, 'fx0883', '', '', 'fx0883@qq.com', 0, 1, '2024-12-08 15:58:02.147338', NULL, NULL, '', 0, NULL, '2024-12-08 15:58:02.412728', '2024-12-09 12:17:52.354775', 36, '2024-12-10 12:18:03.418163', NULL, '~', 1);
INSERT INTO `accounts_historicaluser` VALUES (1, 'pbkdf2_sha256$720000$uxmocJg9Km2K8su1OJ4KLF$mgT2KFTSiOsjAeAbmEyLaQVfaCRQoPPBJIAnDL2Idyw=', '2024-12-10 12:29:13.513917', 0, 'fx0883', '', '', 'fx0883@qq.com', 0, 1, '2024-12-08 15:58:02.147338', NULL, NULL, '', 0, NULL, '2024-12-08 15:58:02.412728', '2024-12-09 12:17:52.354775', 37, '2024-12-10 12:29:13.514686', NULL, '~', 1);
INSERT INTO `accounts_historicaluser` VALUES (1, 'pbkdf2_sha256$720000$uxmocJg9Km2K8su1OJ4KLF$mgT2KFTSiOsjAeAbmEyLaQVfaCRQoPPBJIAnDL2Idyw=', '2024-12-10 12:44:27.539978', 0, 'fx0883', '', '', 'fx0883@qq.com', 0, 1, '2024-12-08 15:58:02.147338', NULL, NULL, '', 0, NULL, '2024-12-08 15:58:02.412728', '2024-12-09 12:17:52.354775', 38, '2024-12-10 12:44:27.541982', NULL, '~', 1);
INSERT INTO `accounts_historicaluser` VALUES (1, 'pbkdf2_sha256$720000$uxmocJg9Km2K8su1OJ4KLF$mgT2KFTSiOsjAeAbmEyLaQVfaCRQoPPBJIAnDL2Idyw=', '2024-12-10 12:46:35.599568', 0, 'fx0883', '', '', 'fx0883@qq.com', 0, 1, '2024-12-08 15:58:02.147338', NULL, NULL, '', 0, NULL, '2024-12-08 15:58:02.412728', '2024-12-09 12:17:52.354775', 39, '2024-12-10 12:46:35.600568', NULL, '~', 1);

-- ----------------------------
-- Table structure for accounts_historicaluserdevice
-- ----------------------------
DROP TABLE IF EXISTS `accounts_historicaluserdevice`;
CREATE TABLE `accounts_historicaluserdevice`  (
  `id` bigint NOT NULL,
  `device_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `device_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `device_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `last_sync_time` datetime(6) NULL DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `history_id` int NOT NULL AUTO_INCREMENT,
  `history_date` datetime(6) NOT NULL,
  `history_change_reason` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `history_type` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `history_user_id` bigint NULL DEFAULT NULL,
  `user_id` bigint NULL DEFAULT NULL,
  PRIMARY KEY (`history_id`) USING BTREE,
  INDEX `accounts_historicalu_history_user_id_2ef58fa6_fk_accounts_`(`history_user_id` ASC) USING BTREE,
  INDEX `accounts_historicaluserdevice_id_45f218b7`(`id` ASC) USING BTREE,
  INDEX `accounts_historicaluserdevice_device_id_aa800ae5`(`device_id` ASC) USING BTREE,
  INDEX `accounts_historicaluserdevice_history_date_3f31d7a6`(`history_date` ASC) USING BTREE,
  INDEX `accounts_historicaluserdevice_user_id_8988ccdf`(`user_id` ASC) USING BTREE,
  CONSTRAINT `accounts_historicalu_history_user_id_2ef58fa6_fk_accounts_` FOREIGN KEY (`history_user_id`) REFERENCES `accounts_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of accounts_historicaluserdevice
-- ----------------------------
INSERT INTO `accounts_historicaluserdevice` VALUES (1, '1', 'device_name', 'device_type', '2024-12-09 12:57:43.118063', 1, '2024-12-09 12:57:43.118063', '2024-12-09 12:57:43.118063', 1, '2024-12-09 12:57:43.122154', NULL, '+', 4, 4);
INSERT INTO `accounts_historicaluserdevice` VALUES (1, '1', 'device_name111111111111111', 'device_type', '2024-12-09 12:00:00.000000', 1, '2024-12-09 12:57:43.118063', '2024-12-09 12:58:16.274892', 2, '2024-12-09 12:58:16.278157', NULL, '~', 4, 1);

-- ----------------------------
-- Table structure for accounts_historicaluserfeedback
-- ----------------------------
DROP TABLE IF EXISTS `accounts_historicaluserfeedback`;
CREATE TABLE `accounts_historicaluserfeedback`  (
  `id` bigint NOT NULL,
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `response` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `history_id` int NOT NULL AUTO_INCREMENT,
  `history_date` datetime(6) NOT NULL,
  `history_change_reason` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `history_type` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `history_user_id` bigint NULL DEFAULT NULL,
  `user_id` bigint NULL DEFAULT NULL,
  PRIMARY KEY (`history_id`) USING BTREE,
  INDEX `accounts_historicalu_history_user_id_e8e5937c_fk_accounts_`(`history_user_id` ASC) USING BTREE,
  INDEX `accounts_historicaluserfeedback_id_42540e66`(`id` ASC) USING BTREE,
  INDEX `accounts_historicaluserfeedback_history_date_2b4eaf13`(`history_date` ASC) USING BTREE,
  INDEX `accounts_historicaluserfeedback_user_id_92cce853`(`user_id` ASC) USING BTREE,
  CONSTRAINT `accounts_historicalu_history_user_id_e8e5937c_fk_accounts_` FOREIGN KEY (`history_user_id`) REFERENCES `accounts_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of accounts_historicaluserfeedback
-- ----------------------------
INSERT INTO `accounts_historicaluserfeedback` VALUES (1, '11string', 's1tring', 'string', 'pending', NULL, '2024-12-09 12:57:05.419654', '2024-12-09 12:57:05.419654', 1, '2024-12-09 12:57:05.423497', NULL, '+', 4, 4);

-- ----------------------------
-- Table structure for accounts_historicaluserprofile
-- ----------------------------
DROP TABLE IF EXISTS `accounts_historicaluserprofile`;
CREATE TABLE `accounts_historicaluserprofile`  (
  `id` bigint NOT NULL,
  `theme` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `notification_preferences` json NOT NULL,
  `timezone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `language` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `history_id` int NOT NULL AUTO_INCREMENT,
  `history_date` datetime(6) NOT NULL,
  `history_change_reason` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `history_type` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `history_user_id` bigint NULL DEFAULT NULL,
  `user_id` bigint NULL DEFAULT NULL,
  PRIMARY KEY (`history_id`) USING BTREE,
  INDEX `accounts_historicalu_history_user_id_c825aedf_fk_accounts_`(`history_user_id` ASC) USING BTREE,
  INDEX `accounts_historicaluserprofile_id_10638df2`(`id` ASC) USING BTREE,
  INDEX `accounts_historicaluserprofile_history_date_8a31e348`(`history_date` ASC) USING BTREE,
  INDEX `accounts_historicaluserprofile_user_id_5132a9c1`(`user_id` ASC) USING BTREE,
  CONSTRAINT `accounts_historicalu_history_user_id_c825aedf_fk_accounts_` FOREIGN KEY (`history_user_id`) REFERENCES `accounts_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of accounts_historicaluserprofile
-- ----------------------------
INSERT INTO `accounts_historicaluserprofile` VALUES (1, 'light', '{}', 'Asia/Shanghai', 'zh-hans', '2024-12-08 15:58:02.412728', '2024-12-08 15:58:02.412728', 1, '2024-12-08 15:58:02.412728', NULL, '+', NULL, 1);
INSERT INTO `accounts_historicaluserprofile` VALUES (2, 'light', '{}', 'Asia/Shanghai', 'zh-hans', '2024-12-09 08:18:36.307507', '2024-12-09 08:18:36.307507', 2, '2024-12-09 08:18:36.308506', NULL, '+', 1, 4);
INSERT INTO `accounts_historicaluserprofile` VALUES (3, 'light', '{}', 'Asia/Shanghai', 'zh-hans', '2024-12-09 15:16:36.347315', '2024-12-09 15:16:36.347315', 3, '2024-12-09 15:16:36.348764', NULL, '+', 1, 5);

-- ----------------------------
-- Table structure for accounts_historicalverificationcode
-- ----------------------------
DROP TABLE IF EXISTS `accounts_historicalverificationcode`;
CREATE TABLE `accounts_historicalverificationcode`  (
  `id` bigint NOT NULL,
  `code` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `purpose` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `is_used` tinyint(1) NOT NULL,
  `expires_at` datetime(6) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `history_id` int NOT NULL AUTO_INCREMENT,
  `history_date` datetime(6) NOT NULL,
  `history_change_reason` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `history_type` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `history_user_id` bigint NULL DEFAULT NULL,
  `user_id` bigint NULL DEFAULT NULL,
  PRIMARY KEY (`history_id`) USING BTREE,
  INDEX `accounts_historicalv_history_user_id_907ba5a8_fk_accounts_`(`history_user_id` ASC) USING BTREE,
  INDEX `accounts_historicalverificationcode_id_aecb13dc`(`id` ASC) USING BTREE,
  INDEX `accounts_historicalverificationcode_history_date_5bbd1b5b`(`history_date` ASC) USING BTREE,
  INDEX `accounts_historicalverificationcode_user_id_59c0c742`(`user_id` ASC) USING BTREE,
  CONSTRAINT `accounts_historicalv_history_user_id_907ba5a8_fk_accounts_` FOREIGN KEY (`history_user_id`) REFERENCES `accounts_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of accounts_historicalverificationcode
-- ----------------------------
INSERT INTO `accounts_historicalverificationcode` VALUES (1, 'gAAAAABnVqoLgqruuGo3Te2RUwC5qCX4HOPerCUUYNIPCVT6HjdYqmOekOfaCnID6wJPIC-dEACy0_0alEYPq0H8E6IkwOudtg==', 'password_reset', 0, '2024-12-09 08:57:55.682662', '2024-12-09 08:27:55.689662', 1, '2024-12-09 08:27:55.692059', NULL, '+', 1, 1);
INSERT INTO `accounts_historicalverificationcode` VALUES (2, 'gAAAAABnVsV3-d11VuVxzDE7hDdhd931JLNLuvfUt8DRj_ehMhkRMmHYKwIcPo_IVt11lDmjSstIAZrq5y9vN0RwT8secNP_bg==', 'password_reset', 0, '2024-12-09 10:54:55.961213', '2024-12-09 10:24:55.988788', 2, '2024-12-09 10:24:55.991023', NULL, '+', 1, 1);
INSERT INTO `accounts_historicalverificationcode` VALUES (3, 'gAAAAABnVsWW8YJOOB6gRcold6208mMo1wLXsk-tLsK6MgtnpdO0MFp9rpxy-kwrpJBBL1011j6qxh_V0jMGmaaunL-Wjxpnvg==', 'password_reset', 0, '2024-12-09 10:55:26.228090', '2024-12-09 10:25:26.236609', 3, '2024-12-09 10:25:26.241210', NULL, '+', 1, 1);
INSERT INTO `accounts_historicalverificationcode` VALUES (4, 'gAAAAABnVsYJ5N14M0b1AR3oQ5PryKSf6Tbj7q3_M6UxbAXx8BmcL-tVag5VRTXujCLsTA5BM9qvY9EO6iRZFtYEHH_wOvDOIQ==', 'password_reset', 0, '2024-12-09 10:57:21.623849', '2024-12-09 10:27:21.631461', 4, '2024-12-09 10:27:21.633454', NULL, '+', 1, 1);
INSERT INTO `accounts_historicalverificationcode` VALUES (5, 'gAAAAABnVtOhZ6xpd94_b5ZnFT27Nv-bA6iKpAnV_n9LMygzn9vvYRYnCK_9JDnvWoZ0uL8Pjqv5F-ZePEkJJg4n23kOR694qw==', 'password_reset', 0, '2024-12-09 11:55:21.263359', '2024-12-09 11:25:21.279067', 5, '2024-12-09 11:25:21.281069', NULL, '+', 1, 1);
INSERT INTO `accounts_historicalverificationcode` VALUES (6, 'gAAAAABnVtQ15byTLsJwVN8ZsodMMvuRo4JUS4Fcqf7Jzy2caIQ88FpnqcAd-leC26n40oUoyhpka-N6yJdXUgjX3YKdTL9xZQ==', 'password_reset', 0, '2024-12-09 11:57:49.199546', '2024-12-09 11:27:49.210206', 6, '2024-12-09 11:27:49.216331', NULL, '+', 1, 1);
INSERT INTO `accounts_historicalverificationcode` VALUES (7, 'gAAAAABnVt3j6xBJqcUOHA3l7l7ym4eNWlZlySlRWV4scZ_8k9Xgvz3E05HiicDC0GgNR88ad9WhlAVXjU2L2HXwu8vGDEpKnQ==', 'password_reset', 0, '2024-12-09 12:39:07.464205', '2024-12-09 12:09:07.475833', 7, '2024-12-09 12:09:07.477838', NULL, '+', 1, 1);
INSERT INTO `accounts_historicalverificationcode` VALUES (8, 'gAAAAABnVt8ntg19LwioXJqBkVQF5WNf2yEMTXksGmA2FlkaquUKNCUPbGIOz1XRh2ZavdaKCU_mWKiV0_zfNangp_HNUzWOPA==', 'password_reset', 0, '2024-12-09 12:44:31.409596', '2024-12-09 12:14:31.418238', 8, '2024-12-09 12:14:31.420747', NULL, '+', NULL, 1);
INSERT INTO `accounts_historicalverificationcode` VALUES (8, 'gAAAAABnVt9nknOWs-WbOfJwOz6SF3DCTfBXqT3YwXNVGt60ISjKZ2KnW1-K4bErLr05sbvv0b2pX8k2jdNEr1ksNBPPhf00nw==', 'password_reset', 1, '2024-12-09 12:44:31.409596', '2024-12-09 12:14:31.418238', 9, '2024-12-09 12:15:35.338016', NULL, '~', NULL, 1);
INSERT INTO `accounts_historicalverificationcode` VALUES (7, 'gAAAAABnVt_wDHSbaL3keDN7I0socm_dCHe7QYsK1mZ2yejxYYBTIkcaxknETq9vMtF2xEnm4-lfOzt8oR0u3bh6v8O2tCGA_w==', 'password_reset', 1, '2024-12-09 12:39:07.464205', '2024-12-09 12:09:07.475833', 10, '2024-12-09 12:17:52.360281', NULL, '~', NULL, 1);

-- ----------------------------
-- Table structure for accounts_user
-- ----------------------------
DROP TABLE IF EXISTS `accounts_user`;
CREATE TABLE `accounts_user`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `password` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `last_login` datetime(6) NULL DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `first_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `last_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `email` varchar(254) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `wechat_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `avatar` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `is_email_verified` tinyint(1) NOT NULL,
  `last_login_ip` char(39) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE,
  UNIQUE INDEX `phone`(`phone` ASC) USING BTREE,
  UNIQUE INDEX `wechat_id`(`wechat_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of accounts_user
-- ----------------------------
INSERT INTO `accounts_user` VALUES (1, 'pbkdf2_sha256$720000$uxmocJg9Km2K8su1OJ4KLF$mgT2KFTSiOsjAeAbmEyLaQVfaCRQoPPBJIAnDL2Idyw=', '2024-12-10 12:46:35.599568', 0, 'fx0883', '', '', 'fx0883@qq.com', 0, 1, '2024-12-08 15:58:02.147338', NULL, NULL, '', 0, NULL, '2024-12-08 15:58:02.412728', '2024-12-09 12:17:52.354775');
INSERT INTO `accounts_user` VALUES (2, 'pbkdf2_sha256$720000$9Wi6vHS8F0kt7bJH9RBWLt$0M56ogXXJBkxnvN36iQWgFc+vuT4pVKSit+EbDucF2U=', '2024-12-09 03:37:04.506469', 1, 'admin', '', '', 'admin@123.com', 1, 1, '2024-12-09 03:36:03.989563', NULL, NULL, '', 0, NULL, '2024-12-09 03:36:04.146217', '2024-12-09 03:36:04.146217');
INSERT INTO `accounts_user` VALUES (4, 'pbkdf2_sha256$720000$Zy0ZM58q3UEaoxexTRDGm6$VtGsqFxMA9rjCPRAvOCHjdJb4irC/QTxogaL8x3o3ig=', '2024-12-10 06:36:34.568279', 0, 'johndoe', 'John', 'Doe', 'john@example.com', 0, 1, '2024-12-09 08:18:36.130906', NULL, NULL, '', 0, NULL, '2024-12-09 08:18:36.303508', '2024-12-09 08:18:36.303508');
INSERT INTO `accounts_user` VALUES (5, 'pbkdf2_sha256$720000$bW47acK4xiv2Rlqp3DQz47$c2bwi67J13kHnBeDFsOhRv547EKbGGKS1slfEdCrggY=', '2024-12-09 15:24:50.197887', 0, 'fx123', '', '', '', 0, 1, '2024-12-09 15:16:36.081430', NULL, NULL, '', 0, NULL, '2024-12-09 15:16:36.342307', '2024-12-09 15:16:36.342307');

-- ----------------------------
-- Table structure for accounts_user_groups
-- ----------------------------
DROP TABLE IF EXISTS `accounts_user_groups`;
CREATE TABLE `accounts_user_groups`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `accounts_user_groups_user_id_group_id_59c0b32f_uniq`(`user_id` ASC, `group_id` ASC) USING BTREE,
  INDEX `accounts_user_groups_group_id_bd11a704_fk_auth_group_id`(`group_id` ASC) USING BTREE,
  CONSTRAINT `accounts_user_groups_group_id_bd11a704_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `accounts_user_groups_user_id_52b62117_fk_accounts_user_id` FOREIGN KEY (`user_id`) REFERENCES `accounts_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of accounts_user_groups
-- ----------------------------

-- ----------------------------
-- Table structure for accounts_user_user_permissions
-- ----------------------------
DROP TABLE IF EXISTS `accounts_user_user_permissions`;
CREATE TABLE `accounts_user_user_permissions`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `accounts_user_user_permi_user_id_permission_id_2ab516c2_uniq`(`user_id` ASC, `permission_id` ASC) USING BTREE,
  INDEX `accounts_user_user_p_permission_id_113bb443_fk_auth_perm`(`permission_id` ASC) USING BTREE,
  CONSTRAINT `accounts_user_user_p_permission_id_113bb443_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `accounts_user_user_p_user_id_e4f0a161_fk_accounts_` FOREIGN KEY (`user_id`) REFERENCES `accounts_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of accounts_user_user_permissions
-- ----------------------------

-- ----------------------------
-- Table structure for accounts_userdevice
-- ----------------------------
DROP TABLE IF EXISTS `accounts_userdevice`;
CREATE TABLE `accounts_userdevice`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `device_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `device_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `device_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `last_sync_time` datetime(6) NULL DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `device_id`(`device_id` ASC) USING BTREE,
  INDEX `accounts_userdevice_user_id_2e91dbfd_fk_accounts_user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `accounts_userdevice_user_id_2e91dbfd_fk_accounts_user_id` FOREIGN KEY (`user_id`) REFERENCES `accounts_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of accounts_userdevice
-- ----------------------------
INSERT INTO `accounts_userdevice` VALUES (1, '1', 'device_name111111111111111', 'device_type', '2024-12-09 12:00:00.000000', 1, '2024-12-09 12:57:43.118063', '2024-12-09 12:58:16.274892', 1);

-- ----------------------------
-- Table structure for accounts_userfeedback
-- ----------------------------
DROP TABLE IF EXISTS `accounts_userfeedback`;
CREATE TABLE `accounts_userfeedback`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `response` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `accounts_userfeedback_user_id_00952b3e_fk_accounts_user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `accounts_userfeedback_user_id_00952b3e_fk_accounts_user_id` FOREIGN KEY (`user_id`) REFERENCES `accounts_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of accounts_userfeedback
-- ----------------------------
INSERT INTO `accounts_userfeedback` VALUES (1, '11string', 's1tring', 'string', 'pending', NULL, '2024-12-09 12:57:05.419654', '2024-12-09 12:57:05.419654', 4);

-- ----------------------------
-- Table structure for accounts_userprofile
-- ----------------------------
DROP TABLE IF EXISTS `accounts_userprofile`;
CREATE TABLE `accounts_userprofile`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `theme` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `notification_preferences` json NOT NULL,
  `timezone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `language` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `accounts_userprofile_user_id_92240672_fk_accounts_user_id` FOREIGN KEY (`user_id`) REFERENCES `accounts_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of accounts_userprofile
-- ----------------------------
INSERT INTO `accounts_userprofile` VALUES (1, 'light', '{}', 'Asia/Shanghai', 'zh-hans', '2024-12-08 15:58:02.412728', '2024-12-08 15:58:02.412728', 1);
INSERT INTO `accounts_userprofile` VALUES (2, 'light', '{}', 'Asia/Shanghai', 'zh-hans', '2024-12-09 08:18:36.307507', '2024-12-09 08:18:36.307507', 4);
INSERT INTO `accounts_userprofile` VALUES (3, 'light', '{}', 'Asia/Shanghai', 'zh-hans', '2024-12-09 15:16:36.347315', '2024-12-09 15:16:36.347315', 5);

-- ----------------------------
-- Table structure for accounts_verificationcode
-- ----------------------------
DROP TABLE IF EXISTS `accounts_verificationcode`;
CREATE TABLE `accounts_verificationcode`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `code` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `purpose` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `is_used` tinyint(1) NOT NULL,
  `expires_at` datetime(6) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `accounts_verificationcode_user_id_91ba36e2_fk_accounts_user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `accounts_verificationcode_user_id_91ba36e2_fk_accounts_user_id` FOREIGN KEY (`user_id`) REFERENCES `accounts_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of accounts_verificationcode
-- ----------------------------
INSERT INTO `accounts_verificationcode` VALUES (1, 'gAAAAABnVqoLnpUranEKuBuOMrI0QWJFuwA8nLl3bd_4hh9P1cFiUNpbD-lXFS_1_AB74e6q45p7QUEQaQEcYD-otjdhzbpSIA==', 'password_reset', 0, '2024-12-09 08:57:55.682662', '2024-12-09 08:27:55.689662', 1);
INSERT INTO `accounts_verificationcode` VALUES (2, 'gAAAAABnVsV3QorZI1auX6WMFF9p2-SKBaOR4WAxq3S8-gCx9UVje85T9Aaz-5zVebQ7J3_LIN_pzhvT3ock27qcBA3KvHJlcw==', 'password_reset', 0, '2024-12-09 10:54:55.961213', '2024-12-09 10:24:55.988788', 1);
INSERT INTO `accounts_verificationcode` VALUES (3, 'gAAAAABnVsWWQHG8sUQsoRCr1wu8JupT6x-_woQIDH9x20Y3SFaWhAfCRt-s4rgUJUtD7oSDnUrb5twQG4xOs4ghmFDc-LVSaQ==', 'password_reset', 0, '2024-12-09 10:55:26.228090', '2024-12-09 10:25:26.236609', 1);
INSERT INTO `accounts_verificationcode` VALUES (4, 'gAAAAABnVsYJ8rWQKi2_GbdSU0XvCp4Jytvm8yJ7NJTUPTtpBfEiEMMwVyX5v9GqwBi9fvIfh3iM-FVw06I01jRqpQ0ZjL6ohw==', 'password_reset', 0, '2024-12-09 10:57:21.623849', '2024-12-09 10:27:21.631461', 1);
INSERT INTO `accounts_verificationcode` VALUES (5, 'gAAAAABnVtOhhH8HfVVuUSjKrRrbwZ7_Dv_GpAQT8mj6jwKbW_RYouAfhxBBpg5Cxl-cTtxNpSIw2gzeQgab2FZeCr41O_6VEQ==', 'password_reset', 0, '2024-12-09 11:55:21.263359', '2024-12-09 11:25:21.279067', 1);
INSERT INTO `accounts_verificationcode` VALUES (6, 'gAAAAABnVtQ1rTSRcpupH24l7jYLOdV_j11_hDoNEnQ52WzgXuzCrk3dB7XJfXQlVSFoaTDOYTDCFsIhAdoqdCByNUeh03PHwg==', 'password_reset', 0, '2024-12-09 11:57:49.199546', '2024-12-09 11:27:49.210206', 1);
INSERT INTO `accounts_verificationcode` VALUES (7, 'gAAAAABnVt_wV0bZgU7g60p_LmGE0egWAOxuuvxakvAQhPUDpm7dpw3WihpR0CmRfDfjsXQyk3MplvjBYjKZACCbsQ7Mfpl60A==', 'password_reset', 1, '2024-12-09 12:39:07.464205', '2024-12-09 12:09:07.475833', 1);
INSERT INTO `accounts_verificationcode` VALUES (8, 'gAAAAABnVt9nZoDXf8R9kBKbT_fvfW-tq7LbFTbjYJM5pm8fQU8TlL_zBIkU_2qn3uB9RTIQnQe6GgPZpa4llau56N7Zfi0pYw==', 'password_reset', 1, '2024-12-09 12:44:31.409596', '2024-12-09 12:14:31.418238', 1);

-- ----------------------------
-- Table structure for auth_group
-- ----------------------------
DROP TABLE IF EXISTS `auth_group`;
CREATE TABLE `auth_group`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_group
-- ----------------------------

-- ----------------------------
-- Table structure for auth_group_permissions
-- ----------------------------
DROP TABLE IF EXISTS `auth_group_permissions`;
CREATE TABLE `auth_group_permissions`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_group_permissions_group_id_permission_id_0cd325b0_uniq`(`group_id` ASC, `permission_id` ASC) USING BTREE,
  INDEX `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm`(`permission_id` ASC) USING BTREE,
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_group_permissions
-- ----------------------------

-- ----------------------------
-- Table structure for auth_permission
-- ----------------------------
DROP TABLE IF EXISTS `auth_permission`;
CREATE TABLE `auth_permission`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_permission_content_type_id_codename_01ab375a_uniq`(`content_type_id` ASC, `codename` ASC) USING BTREE,
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 173 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_permission
-- ----------------------------
INSERT INTO `auth_permission` VALUES (1, 'Can add log entry', 1, 'add_logentry');
INSERT INTO `auth_permission` VALUES (2, 'Can change log entry', 1, 'change_logentry');
INSERT INTO `auth_permission` VALUES (3, 'Can delete log entry', 1, 'delete_logentry');
INSERT INTO `auth_permission` VALUES (4, 'Can view log entry', 1, 'view_logentry');
INSERT INTO `auth_permission` VALUES (5, 'Can add permission', 2, 'add_permission');
INSERT INTO `auth_permission` VALUES (6, 'Can change permission', 2, 'change_permission');
INSERT INTO `auth_permission` VALUES (7, 'Can delete permission', 2, 'delete_permission');
INSERT INTO `auth_permission` VALUES (8, 'Can view permission', 2, 'view_permission');
INSERT INTO `auth_permission` VALUES (9, 'Can add group', 3, 'add_group');
INSERT INTO `auth_permission` VALUES (10, 'Can change group', 3, 'change_group');
INSERT INTO `auth_permission` VALUES (11, 'Can delete group', 3, 'delete_group');
INSERT INTO `auth_permission` VALUES (12, 'Can view group', 3, 'view_group');
INSERT INTO `auth_permission` VALUES (13, 'Can add content type', 4, 'add_contenttype');
INSERT INTO `auth_permission` VALUES (14, 'Can change content type', 4, 'change_contenttype');
INSERT INTO `auth_permission` VALUES (15, 'Can delete content type', 4, 'delete_contenttype');
INSERT INTO `auth_permission` VALUES (16, 'Can view content type', 4, 'view_contenttype');
INSERT INTO `auth_permission` VALUES (17, 'Can add session', 5, 'add_session');
INSERT INTO `auth_permission` VALUES (18, 'Can change session', 5, 'change_session');
INSERT INTO `auth_permission` VALUES (19, 'Can delete session', 5, 'delete_session');
INSERT INTO `auth_permission` VALUES (20, 'Can view session', 5, 'view_session');
INSERT INTO `auth_permission` VALUES (21, 'Can add application', 6, 'add_application');
INSERT INTO `auth_permission` VALUES (22, 'Can change application', 6, 'change_application');
INSERT INTO `auth_permission` VALUES (23, 'Can delete application', 6, 'delete_application');
INSERT INTO `auth_permission` VALUES (24, 'Can view application', 6, 'view_application');
INSERT INTO `auth_permission` VALUES (25, 'Can add access token', 7, 'add_accesstoken');
INSERT INTO `auth_permission` VALUES (26, 'Can change access token', 7, 'change_accesstoken');
INSERT INTO `auth_permission` VALUES (27, 'Can delete access token', 7, 'delete_accesstoken');
INSERT INTO `auth_permission` VALUES (28, 'Can view access token', 7, 'view_accesstoken');
INSERT INTO `auth_permission` VALUES (29, 'Can add grant', 8, 'add_grant');
INSERT INTO `auth_permission` VALUES (30, 'Can change grant', 8, 'change_grant');
INSERT INTO `auth_permission` VALUES (31, 'Can delete grant', 8, 'delete_grant');
INSERT INTO `auth_permission` VALUES (32, 'Can view grant', 8, 'view_grant');
INSERT INTO `auth_permission` VALUES (33, 'Can add refresh token', 9, 'add_refreshtoken');
INSERT INTO `auth_permission` VALUES (34, 'Can change refresh token', 9, 'change_refreshtoken');
INSERT INTO `auth_permission` VALUES (35, 'Can delete refresh token', 9, 'delete_refreshtoken');
INSERT INTO `auth_permission` VALUES (36, 'Can view refresh token', 9, 'view_refreshtoken');
INSERT INTO `auth_permission` VALUES (37, 'Can add id token', 10, 'add_idtoken');
INSERT INTO `auth_permission` VALUES (38, 'Can change id token', 10, 'change_idtoken');
INSERT INTO `auth_permission` VALUES (39, 'Can delete id token', 10, 'delete_idtoken');
INSERT INTO `auth_permission` VALUES (40, 'Can view id token', 10, 'view_idtoken');
INSERT INTO `auth_permission` VALUES (41, 'Can add association', 11, 'add_association');
INSERT INTO `auth_permission` VALUES (42, 'Can change association', 11, 'change_association');
INSERT INTO `auth_permission` VALUES (43, 'Can delete association', 11, 'delete_association');
INSERT INTO `auth_permission` VALUES (44, 'Can view association', 11, 'view_association');
INSERT INTO `auth_permission` VALUES (45, 'Can add code', 12, 'add_code');
INSERT INTO `auth_permission` VALUES (46, 'Can change code', 12, 'change_code');
INSERT INTO `auth_permission` VALUES (47, 'Can delete code', 12, 'delete_code');
INSERT INTO `auth_permission` VALUES (48, 'Can view code', 12, 'view_code');
INSERT INTO `auth_permission` VALUES (49, 'Can add nonce', 13, 'add_nonce');
INSERT INTO `auth_permission` VALUES (50, 'Can change nonce', 13, 'change_nonce');
INSERT INTO `auth_permission` VALUES (51, 'Can delete nonce', 13, 'delete_nonce');
INSERT INTO `auth_permission` VALUES (52, 'Can view nonce', 13, 'view_nonce');
INSERT INTO `auth_permission` VALUES (53, 'Can add user social auth', 14, 'add_usersocialauth');
INSERT INTO `auth_permission` VALUES (54, 'Can change user social auth', 14, 'change_usersocialauth');
INSERT INTO `auth_permission` VALUES (55, 'Can delete user social auth', 14, 'delete_usersocialauth');
INSERT INTO `auth_permission` VALUES (56, 'Can view user social auth', 14, 'view_usersocialauth');
INSERT INTO `auth_permission` VALUES (57, 'Can add partial', 15, 'add_partial');
INSERT INTO `auth_permission` VALUES (58, 'Can change partial', 15, 'change_partial');
INSERT INTO `auth_permission` VALUES (59, 'Can delete partial', 15, 'delete_partial');
INSERT INTO `auth_permission` VALUES (60, 'Can view partial', 15, 'view_partial');
INSERT INTO `auth_permission` VALUES (61, 'Can add 用户', 16, 'add_user');
INSERT INTO `auth_permission` VALUES (62, 'Can change 用户', 16, 'change_user');
INSERT INTO `auth_permission` VALUES (63, 'Can delete 用户', 16, 'delete_user');
INSERT INTO `auth_permission` VALUES (64, 'Can view 用户', 16, 'view_user');
INSERT INTO `auth_permission` VALUES (65, 'Can add historical 用户', 17, 'add_historicaluser');
INSERT INTO `auth_permission` VALUES (66, 'Can change historical 用户', 17, 'change_historicaluser');
INSERT INTO `auth_permission` VALUES (67, 'Can delete historical 用户', 17, 'delete_historicaluser');
INSERT INTO `auth_permission` VALUES (68, 'Can view historical 用户', 17, 'view_historicaluser');
INSERT INTO `auth_permission` VALUES (69, 'Can add historical 用户设备', 18, 'add_historicaluserdevice');
INSERT INTO `auth_permission` VALUES (70, 'Can change historical 用户设备', 18, 'change_historicaluserdevice');
INSERT INTO `auth_permission` VALUES (71, 'Can delete historical 用户设备', 18, 'delete_historicaluserdevice');
INSERT INTO `auth_permission` VALUES (72, 'Can view historical 用户设备', 18, 'view_historicaluserdevice');
INSERT INTO `auth_permission` VALUES (73, 'Can add historical 用户配置', 19, 'add_historicaluserprofile');
INSERT INTO `auth_permission` VALUES (74, 'Can change historical 用户配置', 19, 'change_historicaluserprofile');
INSERT INTO `auth_permission` VALUES (75, 'Can delete historical 用户配置', 19, 'delete_historicaluserprofile');
INSERT INTO `auth_permission` VALUES (76, 'Can view historical 用户配置', 19, 'view_historicaluserprofile');
INSERT INTO `auth_permission` VALUES (77, 'Can add historical 验证码', 20, 'add_historicalverificationcode');
INSERT INTO `auth_permission` VALUES (78, 'Can change historical 验证码', 20, 'change_historicalverificationcode');
INSERT INTO `auth_permission` VALUES (79, 'Can delete historical 验证码', 20, 'delete_historicalverificationcode');
INSERT INTO `auth_permission` VALUES (80, 'Can view historical 验证码', 20, 'view_historicalverificationcode');
INSERT INTO `auth_permission` VALUES (81, 'Can add 用户设备', 21, 'add_userdevice');
INSERT INTO `auth_permission` VALUES (82, 'Can change 用户设备', 21, 'change_userdevice');
INSERT INTO `auth_permission` VALUES (83, 'Can delete 用户设备', 21, 'delete_userdevice');
INSERT INTO `auth_permission` VALUES (84, 'Can view 用户设备', 21, 'view_userdevice');
INSERT INTO `auth_permission` VALUES (85, 'Can add 用户配置', 22, 'add_userprofile');
INSERT INTO `auth_permission` VALUES (86, 'Can change 用户配置', 22, 'change_userprofile');
INSERT INTO `auth_permission` VALUES (87, 'Can delete 用户配置', 22, 'delete_userprofile');
INSERT INTO `auth_permission` VALUES (88, 'Can view 用户配置', 22, 'view_userprofile');
INSERT INTO `auth_permission` VALUES (89, 'Can add 验证码', 23, 'add_verificationcode');
INSERT INTO `auth_permission` VALUES (90, 'Can change 验证码', 23, 'change_verificationcode');
INSERT INTO `auth_permission` VALUES (91, 'Can delete 验证码', 23, 'delete_verificationcode');
INSERT INTO `auth_permission` VALUES (92, 'Can view 验证码', 23, 'view_verificationcode');
INSERT INTO `auth_permission` VALUES (93, 'Can add 分类', 24, 'add_category');
INSERT INTO `auth_permission` VALUES (94, 'Can change 分类', 24, 'change_category');
INSERT INTO `auth_permission` VALUES (95, 'Can delete 分类', 24, 'delete_category');
INSERT INTO `auth_permission` VALUES (96, 'Can view 分类', 24, 'view_category');
INSERT INTO `auth_permission` VALUES (97, 'Can add historical 分类', 25, 'add_historicalcategory');
INSERT INTO `auth_permission` VALUES (98, 'Can change historical 分类', 25, 'change_historicalcategory');
INSERT INTO `auth_permission` VALUES (99, 'Can delete historical 分类', 25, 'delete_historicalcategory');
INSERT INTO `auth_permission` VALUES (100, 'Can view historical 分类', 25, 'view_historicalcategory');
INSERT INTO `auth_permission` VALUES (101, 'Can add historical 标签', 26, 'add_historicaltag');
INSERT INTO `auth_permission` VALUES (102, 'Can change historical 标签', 26, 'change_historicaltag');
INSERT INTO `auth_permission` VALUES (103, 'Can delete historical 标签', 26, 'delete_historicaltag');
INSERT INTO `auth_permission` VALUES (104, 'Can view historical 标签', 26, 'view_historicaltag');
INSERT INTO `auth_permission` VALUES (105, 'Can add historical 任务', 27, 'add_historicaltask');
INSERT INTO `auth_permission` VALUES (106, 'Can change historical 任务', 27, 'change_historicaltask');
INSERT INTO `auth_permission` VALUES (107, 'Can delete historical 任务', 27, 'delete_historicaltask');
INSERT INTO `auth_permission` VALUES (108, 'Can view historical 任务', 27, 'view_historicaltask');
INSERT INTO `auth_permission` VALUES (109, 'Can add 标签', 28, 'add_tag');
INSERT INTO `auth_permission` VALUES (110, 'Can change 标签', 28, 'change_tag');
INSERT INTO `auth_permission` VALUES (111, 'Can delete 标签', 28, 'delete_tag');
INSERT INTO `auth_permission` VALUES (112, 'Can view 标签', 28, 'view_tag');
INSERT INTO `auth_permission` VALUES (113, 'Can add 任务', 29, 'add_task');
INSERT INTO `auth_permission` VALUES (114, 'Can change 任务', 29, 'change_task');
INSERT INTO `auth_permission` VALUES (115, 'Can delete 任务', 29, 'delete_task');
INSERT INTO `auth_permission` VALUES (116, 'Can view 任务', 29, 'view_task');
INSERT INTO `auth_permission` VALUES (117, 'Can add historical 任务同步', 30, 'add_historicaltasksync');
INSERT INTO `auth_permission` VALUES (118, 'Can change historical 任务同步', 30, 'change_historicaltasksync');
INSERT INTO `auth_permission` VALUES (119, 'Can delete historical 任务同步', 30, 'delete_historicaltasksync');
INSERT INTO `auth_permission` VALUES (120, 'Can view historical 任务同步', 30, 'view_historicaltasksync');
INSERT INTO `auth_permission` VALUES (121, 'Can add historical 任务评论', 31, 'add_historicaltaskcomment');
INSERT INTO `auth_permission` VALUES (122, 'Can change historical 任务评论', 31, 'change_historicaltaskcomment');
INSERT INTO `auth_permission` VALUES (123, 'Can delete historical 任务评论', 31, 'delete_historicaltaskcomment');
INSERT INTO `auth_permission` VALUES (124, 'Can view historical 任务评论', 31, 'view_historicaltaskcomment');
INSERT INTO `auth_permission` VALUES (125, 'Can add 任务评论', 32, 'add_taskcomment');
INSERT INTO `auth_permission` VALUES (126, 'Can change 任务评论', 32, 'change_taskcomment');
INSERT INTO `auth_permission` VALUES (127, 'Can delete 任务评论', 32, 'delete_taskcomment');
INSERT INTO `auth_permission` VALUES (128, 'Can view 任务评论', 32, 'view_taskcomment');
INSERT INTO `auth_permission` VALUES (129, 'Can add 任务同步', 33, 'add_tasksync');
INSERT INTO `auth_permission` VALUES (130, 'Can change 任务同步', 33, 'change_tasksync');
INSERT INTO `auth_permission` VALUES (131, 'Can delete 任务同步', 33, 'delete_tasksync');
INSERT INTO `auth_permission` VALUES (132, 'Can view 任务同步', 33, 'view_tasksync');
INSERT INTO `auth_permission` VALUES (133, 'Can add 通知模板', 34, 'add_notificationtemplate');
INSERT INTO `auth_permission` VALUES (134, 'Can change 通知模板', 34, 'change_notificationtemplate');
INSERT INTO `auth_permission` VALUES (135, 'Can delete 通知模板', 34, 'delete_notificationtemplate');
INSERT INTO `auth_permission` VALUES (136, 'Can view 通知模板', 34, 'view_notificationtemplate');
INSERT INTO `auth_permission` VALUES (137, 'Can add historical 通知设备', 35, 'add_historicalnotificationdevice');
INSERT INTO `auth_permission` VALUES (138, 'Can change historical 通知设备', 35, 'change_historicalnotificationdevice');
INSERT INTO `auth_permission` VALUES (139, 'Can delete historical 通知设备', 35, 'delete_historicalnotificationdevice');
INSERT INTO `auth_permission` VALUES (140, 'Can view historical 通知设备', 35, 'view_historicalnotificationdevice');
INSERT INTO `auth_permission` VALUES (141, 'Can add historical 通知模板', 36, 'add_historicalnotificationtemplate');
INSERT INTO `auth_permission` VALUES (142, 'Can change historical 通知模板', 36, 'change_historicalnotificationtemplate');
INSERT INTO `auth_permission` VALUES (143, 'Can delete historical 通知模板', 36, 'delete_historicalnotificationtemplate');
INSERT INTO `auth_permission` VALUES (144, 'Can view historical 通知模板', 36, 'view_historicalnotificationtemplate');
INSERT INTO `auth_permission` VALUES (145, 'Can add 通知', 37, 'add_notification');
INSERT INTO `auth_permission` VALUES (146, 'Can change 通知', 37, 'change_notification');
INSERT INTO `auth_permission` VALUES (147, 'Can delete 通知', 37, 'delete_notification');
INSERT INTO `auth_permission` VALUES (148, 'Can view 通知', 37, 'view_notification');
INSERT INTO `auth_permission` VALUES (149, 'Can add historical 通知', 38, 'add_historicalnotification');
INSERT INTO `auth_permission` VALUES (150, 'Can change historical 通知', 38, 'change_historicalnotification');
INSERT INTO `auth_permission` VALUES (151, 'Can delete historical 通知', 38, 'delete_historicalnotification');
INSERT INTO `auth_permission` VALUES (152, 'Can view historical 通知', 38, 'view_historicalnotification');
INSERT INTO `auth_permission` VALUES (153, 'Can add 通知设备', 39, 'add_notificationdevice');
INSERT INTO `auth_permission` VALUES (154, 'Can change 通知设备', 39, 'change_notificationdevice');
INSERT INTO `auth_permission` VALUES (155, 'Can delete 通知设备', 39, 'delete_notificationdevice');
INSERT INTO `auth_permission` VALUES (156, 'Can view 通知设备', 39, 'view_notificationdevice');
INSERT INTO `auth_permission` VALUES (157, 'Can add Token', 40, 'add_token');
INSERT INTO `auth_permission` VALUES (158, 'Can change Token', 40, 'change_token');
INSERT INTO `auth_permission` VALUES (159, 'Can delete Token', 40, 'delete_token');
INSERT INTO `auth_permission` VALUES (160, 'Can view Token', 40, 'view_token');
INSERT INTO `auth_permission` VALUES (161, 'Can add token', 41, 'add_tokenproxy');
INSERT INTO `auth_permission` VALUES (162, 'Can change token', 41, 'change_tokenproxy');
INSERT INTO `auth_permission` VALUES (163, 'Can delete token', 41, 'delete_tokenproxy');
INSERT INTO `auth_permission` VALUES (164, 'Can view token', 41, 'view_tokenproxy');
INSERT INTO `auth_permission` VALUES (165, 'Can add historical 用户反馈', 42, 'add_historicaluserfeedback');
INSERT INTO `auth_permission` VALUES (166, 'Can change historical 用户反馈', 42, 'change_historicaluserfeedback');
INSERT INTO `auth_permission` VALUES (167, 'Can delete historical 用户反馈', 42, 'delete_historicaluserfeedback');
INSERT INTO `auth_permission` VALUES (168, 'Can view historical 用户反馈', 42, 'view_historicaluserfeedback');
INSERT INTO `auth_permission` VALUES (169, 'Can add 用户反馈', 43, 'add_userfeedback');
INSERT INTO `auth_permission` VALUES (170, 'Can change 用户反馈', 43, 'change_userfeedback');
INSERT INTO `auth_permission` VALUES (171, 'Can delete 用户反馈', 43, 'delete_userfeedback');
INSERT INTO `auth_permission` VALUES (172, 'Can view 用户反馈', 43, 'view_userfeedback');

-- ----------------------------
-- Table structure for authtoken_token
-- ----------------------------
DROP TABLE IF EXISTS `authtoken_token`;
CREATE TABLE `authtoken_token`  (
  `key` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `created` datetime(6) NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`key`) USING BTREE,
  UNIQUE INDEX `user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `authtoken_token_user_id_35299eff_fk_accounts_user_id` FOREIGN KEY (`user_id`) REFERENCES `accounts_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of authtoken_token
-- ----------------------------
INSERT INTO `authtoken_token` VALUES ('573cd4d0fab0706eed4416858adec2ff44eeff59', '2024-12-08 16:00:19.194812', 1);
INSERT INTO `authtoken_token` VALUES ('c40fec31709870055accea703ecb5e05fd9576d0', '2024-12-09 15:16:36.352312', 5);
INSERT INTO `authtoken_token` VALUES ('d7926b287f38c0d0336e7d1045f055311acb06d5', '2024-12-09 08:18:36.312015', 4);

-- ----------------------------
-- Table structure for django_admin_log
-- ----------------------------
DROP TABLE IF EXISTS `django_admin_log`;
CREATE TABLE `django_admin_log`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `object_repr` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `action_flag` smallint UNSIGNED NOT NULL,
  `change_message` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content_type_id` int NULL DEFAULT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `django_admin_log_content_type_id_c4bce8eb_fk_django_co`(`content_type_id` ASC) USING BTREE,
  INDEX `django_admin_log_user_id_c564eba6_fk_accounts_user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_accounts_user_id` FOREIGN KEY (`user_id`) REFERENCES `accounts_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `django_admin_log_chk_1` CHECK (`action_flag` >= 0)
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_admin_log
-- ----------------------------

-- ----------------------------
-- Table structure for django_content_type
-- ----------------------------
DROP TABLE IF EXISTS `django_content_type`;
CREATE TABLE `django_content_type`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `model` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `django_content_type_app_label_model_76bd3d3b_uniq`(`app_label` ASC, `model` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 44 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_content_type
-- ----------------------------
INSERT INTO `django_content_type` VALUES (17, 'accounts', 'historicaluser');
INSERT INTO `django_content_type` VALUES (18, 'accounts', 'historicaluserdevice');
INSERT INTO `django_content_type` VALUES (42, 'accounts', 'historicaluserfeedback');
INSERT INTO `django_content_type` VALUES (19, 'accounts', 'historicaluserprofile');
INSERT INTO `django_content_type` VALUES (20, 'accounts', 'historicalverificationcode');
INSERT INTO `django_content_type` VALUES (16, 'accounts', 'user');
INSERT INTO `django_content_type` VALUES (21, 'accounts', 'userdevice');
INSERT INTO `django_content_type` VALUES (43, 'accounts', 'userfeedback');
INSERT INTO `django_content_type` VALUES (22, 'accounts', 'userprofile');
INSERT INTO `django_content_type` VALUES (23, 'accounts', 'verificationcode');
INSERT INTO `django_content_type` VALUES (1, 'admin', 'logentry');
INSERT INTO `django_content_type` VALUES (3, 'auth', 'group');
INSERT INTO `django_content_type` VALUES (2, 'auth', 'permission');
INSERT INTO `django_content_type` VALUES (40, 'authtoken', 'token');
INSERT INTO `django_content_type` VALUES (41, 'authtoken', 'tokenproxy');
INSERT INTO `django_content_type` VALUES (4, 'contenttypes', 'contenttype');
INSERT INTO `django_content_type` VALUES (38, 'notifications', 'historicalnotification');
INSERT INTO `django_content_type` VALUES (35, 'notifications', 'historicalnotificationdevice');
INSERT INTO `django_content_type` VALUES (36, 'notifications', 'historicalnotificationtemplate');
INSERT INTO `django_content_type` VALUES (37, 'notifications', 'notification');
INSERT INTO `django_content_type` VALUES (39, 'notifications', 'notificationdevice');
INSERT INTO `django_content_type` VALUES (34, 'notifications', 'notificationtemplate');
INSERT INTO `django_content_type` VALUES (7, 'oauth2_provider', 'accesstoken');
INSERT INTO `django_content_type` VALUES (6, 'oauth2_provider', 'application');
INSERT INTO `django_content_type` VALUES (8, 'oauth2_provider', 'grant');
INSERT INTO `django_content_type` VALUES (10, 'oauth2_provider', 'idtoken');
INSERT INTO `django_content_type` VALUES (9, 'oauth2_provider', 'refreshtoken');
INSERT INTO `django_content_type` VALUES (5, 'sessions', 'session');
INSERT INTO `django_content_type` VALUES (11, 'social_django', 'association');
INSERT INTO `django_content_type` VALUES (12, 'social_django', 'code');
INSERT INTO `django_content_type` VALUES (13, 'social_django', 'nonce');
INSERT INTO `django_content_type` VALUES (15, 'social_django', 'partial');
INSERT INTO `django_content_type` VALUES (14, 'social_django', 'usersocialauth');
INSERT INTO `django_content_type` VALUES (24, 'tasks', 'category');
INSERT INTO `django_content_type` VALUES (25, 'tasks', 'historicalcategory');
INSERT INTO `django_content_type` VALUES (26, 'tasks', 'historicaltag');
INSERT INTO `django_content_type` VALUES (27, 'tasks', 'historicaltask');
INSERT INTO `django_content_type` VALUES (31, 'tasks', 'historicaltaskcomment');
INSERT INTO `django_content_type` VALUES (30, 'tasks', 'historicaltasksync');
INSERT INTO `django_content_type` VALUES (28, 'tasks', 'tag');
INSERT INTO `django_content_type` VALUES (29, 'tasks', 'task');
INSERT INTO `django_content_type` VALUES (32, 'tasks', 'taskcomment');
INSERT INTO `django_content_type` VALUES (33, 'tasks', 'tasksync');

-- ----------------------------
-- Table structure for django_migrations
-- ----------------------------
DROP TABLE IF EXISTS `django_migrations`;
CREATE TABLE `django_migrations`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 58 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_migrations
-- ----------------------------
INSERT INTO `django_migrations` VALUES (1, 'contenttypes', '0001_initial', '2024-12-08 15:51:37.191556');
INSERT INTO `django_migrations` VALUES (2, 'contenttypes', '0002_remove_content_type_name', '2024-12-08 15:51:37.212847');
INSERT INTO `django_migrations` VALUES (3, 'auth', '0001_initial', '2024-12-08 15:51:37.306028');
INSERT INTO `django_migrations` VALUES (4, 'auth', '0002_alter_permission_name_max_length', '2024-12-08 15:51:37.327673');
INSERT INTO `django_migrations` VALUES (5, 'auth', '0003_alter_user_email_max_length', '2024-12-08 15:51:37.331873');
INSERT INTO `django_migrations` VALUES (6, 'auth', '0004_alter_user_username_opts', '2024-12-08 15:51:37.335891');
INSERT INTO `django_migrations` VALUES (7, 'auth', '0005_alter_user_last_login_null', '2024-12-08 15:51:37.339290');
INSERT INTO `django_migrations` VALUES (8, 'auth', '0006_require_contenttypes_0002', '2024-12-08 15:51:37.340339');
INSERT INTO `django_migrations` VALUES (9, 'auth', '0007_alter_validators_add_error_messages', '2024-12-08 15:51:37.344391');
INSERT INTO `django_migrations` VALUES (10, 'auth', '0008_alter_user_username_max_length', '2024-12-08 15:51:37.347993');
INSERT INTO `django_migrations` VALUES (11, 'auth', '0009_alter_user_last_name_max_length', '2024-12-08 15:51:37.351296');
INSERT INTO `django_migrations` VALUES (12, 'auth', '0010_alter_group_name_max_length', '2024-12-08 15:51:37.359443');
INSERT INTO `django_migrations` VALUES (13, 'auth', '0011_update_proxy_permissions', '2024-12-08 15:51:37.363541');
INSERT INTO `django_migrations` VALUES (14, 'auth', '0012_alter_user_first_name_max_length', '2024-12-08 15:51:37.367246');
INSERT INTO `django_migrations` VALUES (15, 'accounts', '0001_initial', '2024-12-08 15:51:37.815371');
INSERT INTO `django_migrations` VALUES (16, 'admin', '0001_initial', '2024-12-08 15:51:37.871723');
INSERT INTO `django_migrations` VALUES (17, 'admin', '0002_logentry_remove_auto_add', '2024-12-08 15:51:37.883055');
INSERT INTO `django_migrations` VALUES (18, 'admin', '0003_logentry_add_action_flag_choices', '2024-12-08 15:51:37.895859');
INSERT INTO `django_migrations` VALUES (19, 'notifications', '0001_initial', '2024-12-08 15:51:38.208232');
INSERT INTO `django_migrations` VALUES (20, 'oauth2_provider', '0001_initial', '2024-12-08 15:51:38.508010');
INSERT INTO `django_migrations` VALUES (21, 'oauth2_provider', '0002_auto_20190406_1805', '2024-12-08 15:51:38.561306');
INSERT INTO `django_migrations` VALUES (22, 'oauth2_provider', '0003_auto_20201211_1314', '2024-12-08 15:51:38.595539');
INSERT INTO `django_migrations` VALUES (23, 'oauth2_provider', '0004_auto_20200902_2022', '2024-12-08 15:51:38.843750');
INSERT INTO `django_migrations` VALUES (24, 'oauth2_provider', '0005_auto_20211222_2352', '2024-12-08 15:51:38.920791');
INSERT INTO `django_migrations` VALUES (25, 'oauth2_provider', '0006_alter_application_client_secret', '2024-12-08 15:51:38.954049');
INSERT INTO `django_migrations` VALUES (26, 'oauth2_provider', '0007_application_post_logout_redirect_uris', '2024-12-08 15:51:38.996172');
INSERT INTO `django_migrations` VALUES (27, 'sessions', '0001_initial', '2024-12-08 15:51:39.012915');
INSERT INTO `django_migrations` VALUES (28, 'default', '0001_initial', '2024-12-08 15:51:39.119750');
INSERT INTO `django_migrations` VALUES (29, 'social_auth', '0001_initial', '2024-12-08 15:51:39.120271');
INSERT INTO `django_migrations` VALUES (30, 'default', '0002_add_related_name', '2024-12-08 15:51:39.135354');
INSERT INTO `django_migrations` VALUES (31, 'social_auth', '0002_add_related_name', '2024-12-08 15:51:39.136936');
INSERT INTO `django_migrations` VALUES (32, 'default', '0003_alter_email_max_length', '2024-12-08 15:51:39.143725');
INSERT INTO `django_migrations` VALUES (33, 'social_auth', '0003_alter_email_max_length', '2024-12-08 15:51:39.144617');
INSERT INTO `django_migrations` VALUES (34, 'default', '0004_auto_20160423_0400', '2024-12-08 15:51:39.158794');
INSERT INTO `django_migrations` VALUES (35, 'social_auth', '0004_auto_20160423_0400', '2024-12-08 15:51:39.160893');
INSERT INTO `django_migrations` VALUES (36, 'social_auth', '0005_auto_20160727_2333', '2024-12-08 15:51:39.170364');
INSERT INTO `django_migrations` VALUES (37, 'social_django', '0006_partial', '2024-12-08 15:51:39.188716');
INSERT INTO `django_migrations` VALUES (38, 'social_django', '0007_code_timestamp', '2024-12-08 15:51:39.205610');
INSERT INTO `django_migrations` VALUES (39, 'social_django', '0008_partial_timestamp', '2024-12-08 15:51:39.221820');
INSERT INTO `django_migrations` VALUES (40, 'social_django', '0009_auto_20191118_0520', '2024-12-08 15:51:39.269783');
INSERT INTO `django_migrations` VALUES (41, 'social_django', '0010_uid_db_index', '2024-12-08 15:51:39.291151');
INSERT INTO `django_migrations` VALUES (42, 'social_django', '0011_alter_id_fields', '2024-12-08 15:51:39.467179');
INSERT INTO `django_migrations` VALUES (43, 'social_django', '0012_usersocialauth_extra_data_new', '2024-12-08 15:51:39.518703');
INSERT INTO `django_migrations` VALUES (44, 'social_django', '0013_migrate_extra_data', '2024-12-08 15:51:39.537589');
INSERT INTO `django_migrations` VALUES (45, 'social_django', '0014_remove_usersocialauth_extra_data', '2024-12-08 15:51:39.563802');
INSERT INTO `django_migrations` VALUES (46, 'social_django', '0015_rename_extra_data_new_usersocialauth_extra_data', '2024-12-08 15:51:39.594709');
INSERT INTO `django_migrations` VALUES (47, 'tasks', '0001_initial', '2024-12-08 15:51:40.287392');
INSERT INTO `django_migrations` VALUES (48, 'social_django', '0005_auto_20160727_2333', '2024-12-08 15:51:40.289601');
INSERT INTO `django_migrations` VALUES (49, 'social_django', '0004_auto_20160423_0400', '2024-12-08 15:51:40.290608');
INSERT INTO `django_migrations` VALUES (50, 'social_django', '0002_add_related_name', '2024-12-08 15:51:40.291610');
INSERT INTO `django_migrations` VALUES (51, 'social_django', '0001_initial', '2024-12-08 15:51:40.292607');
INSERT INTO `django_migrations` VALUES (52, 'social_django', '0003_alter_email_max_length', '2024-12-08 15:51:40.293681');
INSERT INTO `django_migrations` VALUES (53, 'authtoken', '0001_initial', '2024-12-08 15:59:48.604109');
INSERT INTO `django_migrations` VALUES (54, 'authtoken', '0002_auto_20160226_1747', '2024-12-08 15:59:48.679724');
INSERT INTO `django_migrations` VALUES (55, 'authtoken', '0003_tokenproxy', '2024-12-08 15:59:48.687692');
INSERT INTO `django_migrations` VALUES (56, 'accounts', '0002_historicaluserfeedback_userfeedback', '2024-12-09 08:24:37.108800');
INSERT INTO `django_migrations` VALUES (57, 'tasks', '0002_alter_category_unique_together', '2024-12-09 08:26:20.949611');

-- ----------------------------
-- Table structure for django_session
-- ----------------------------
DROP TABLE IF EXISTS `django_session`;
CREATE TABLE `django_session`  (
  `session_key` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `session_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`) USING BTREE,
  INDEX `django_session_expire_date_a5c62663`(`expire_date` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_session
-- ----------------------------
INSERT INTO `django_session` VALUES ('10it994uv2e0ywmexuojk8xs5oydipvb', '.eJxVjEEOwiAURO_C2hAqfEJduvcM5MOAVA1NSrsy3t2SdKGL2cx7M2_heVuL31pa_ARxEYM4_XaB4zPVDvDgep9lnOu6TEF2RR60yduM9Loe7t9B4Vb6-mzZuETIFLNxAIxyNAJjgMl6CMw7UszsKNuUCZFIEWtl92gtPl8YgDjo:1tKemH:pulRvJjWFhpFGdWQjSPeJyPAeZ4VKhv1lXq2BtWMatE', '2024-12-23 14:30:25.752356');
INSERT INTO `django_session` VALUES ('1uzzxneaaitbzlhz35rj7ve5ov4hzpet', '.eJxVjDsOwjAQBe_iGln-xcaU9DmDtd5d4wBypDipEHeHSCmgfTPzXiLBtta0dV7SROIinDj9bhnwwW0HdId2myXObV2mLHdFHrTLcSZ-Xg_376BCr986DKhBcSTrWFvA4JmM8oGA0WFmLDlGyN5qoGDPBVAXpzQaGMAaE8T7Aw0bONg:1tKegC:vFO0PKmBX5ICWqH9nmt1cH-2qPbp4KbrWVDza0Fc_pE', '2024-12-23 14:24:08.918271');
INSERT INTO `django_session` VALUES ('2dwz6b6y1xwo8bm5vewejjndkq3ggxrp', '.eJxVjEEOwiAURO_C2hAqfEJduvcM5MOAVA1NSrsy3t2SdKGL2cx7M2_heVuL31pa_ARxEYM4_XaB4zPVDvDgep9lnOu6TEF2RR60yduM9Loe7t9B4Vb6-mzZuETIFLNxAIxyNAJjgMl6CMw7UszsKNuUCZFIEWtl92gtPl8YgDjo:1tKzMX:QQ7-kc83nyLd7oRXu-YzCnguwMbNX7af9_ouXlpaVVM', '2024-12-24 12:29:13.517236');
INSERT INTO `django_session` VALUES ('2hpe4grzzk20pujc6gpvgbthu0vg8my6', '.eJxVjDEOwjAMRe-SGUUlOHXNyM4Zojh2SAGlUtNOiLtDpQ6w_vfef5kQ16WEtekcRjFnczSH341jemjdgNxjvU02TXWZR7abYnfa7HUSfV529--gxFa-dQeOFSlnQvB8QvUOO845Ow-k6jkKA1OPSt4NHnvgIUUAQQJRIvP-AOj1OAY:1tKU5D:wtu8DF9TgM8ashsEHohPxb52Vhaj9weuKQ3hOiDy2_k', '2024-12-23 03:05:15.178856');
INSERT INTO `django_session` VALUES ('565doi7w40718omzpeaj2yze1vw2wpth', '.eJxVjEEOwiAURO_C2hAqfEJduvcM5MOAVA1NSrsy3t2SdKGL2cx7M2_heVuL31pa_ARxEYM4_XaB4zPVDvDgep9lnOu6TEF2RR60yduM9Loe7t9B4Vb6-mzZuETIFLNxAIxyNAJjgMl6CMw7UszsKNuUCZFIEWtl92gtPl8YgDjo:1tKexX:6zmSfyr7JWdwJVBSM9wira_szA1YYMwi5Y_PSY7nbuw', '2024-12-23 14:42:03.481256');
INSERT INTO `django_session` VALUES ('5mv66wj1jrmvqubs7du17ytp7s9tnqg1', '.eJxVjDEOwjAMRe-SGUUlOHXNyM4Zojh2SAGlUtNOiLtDpQ6w_vfef5kQ16WEtekcRjFnczSH341jemjdgNxjvU02TXWZR7abYnfa7HUSfV529--gxFa-dQeOFSlnQvB8QvUOO845Ow-k6jkKA1OPSt4NHnvgIUUAQQJRIvP-AOj1OAY:1tKJk0:t3B1upAR8-hgVNGGHTWKbkHHnMutfgngih2dpZO4HPE', '2024-12-22 16:02:40.494509');
INSERT INTO `django_session` VALUES ('76vzzqrxqxjql40smr48i4mrqx1vubxy', '.eJxVjEEOwiAURO_C2hAqfEJduvcM5MOAVA1NSrsy3t2SdKGL2cx7M2_heVuL31pa_ARxEYM4_XaB4zPVDvDgep9lnOu6TEF2RR60yduM9Loe7t9B4Vb6-mzZuETIFLNxAIxyNAJjgMl6CMw7UszsKNuUCZFIEWtl92gtPl8YgDjo:1tKtpx:l5Awemlc8WN2HGcdpyo_XHEuWX-rdsdM7zfoI4PttkQ', '2024-12-24 06:35:13.133453');
INSERT INTO `django_session` VALUES ('cab0vnbd3085d5vn97enkhoyvwm1e9bp', '.eJxVjEEOwiAURO_C2hAqfEJduvcM5MOAVA1NSrsy3t2SdKGL2cx7M2_heVuL31pa_ARxEYM4_XaB4zPVDvDgep9lnOu6TEF2RR60yduM9Loe7t9B4Vb6-mzZuETIFLNxAIxyNAJjgMl6CMw7UszsKNuUCZFIEWtl92gtPl8YgDjo:1tKere:EsNLscgQuZamiGqHVo_bELxslohxARCeCbtTHzV2T6Q', '2024-12-23 14:35:58.144134');
INSERT INTO `django_session` VALUES ('cd1fvle8wkp78n17vmcacimfld1iduv5', '.eJxVjEEOwiAURO_C2hAqfEJduvcM5MOAVA1NSrsy3t2SdKGL2cx7M2_heVuL31pa_ARxEYM4_XaB4zPVDvDgep9lnOu6TEF2RR60yduM9Loe7t9B4Vb6-mzZuETIFLNxAIxyNAJjgMl6CMw7UszsKNuUCZFIEWtl92gtPl8YgDjo:1tKzdL:Tla2aK5kmlPnA7jF6TUzJZLsKWmp14LJjXxjYWyH7_8', '2024-12-24 12:46:35.603569');
INSERT INTO `django_session` VALUES ('d00jovvexr9wuo04e0ww4z6fzp5srjxd', '.eJxVjEEOwiAURO_C2hAqfEJduvcM5MOAVA1NSrsy3t2SdKGL2cx7M2_heVuL31pa_ARxEYM4_XaB4zPVDvDgep9lnOu6TEF2RR60yduM9Loe7t9B4Vb6-mzZuETIFLNxAIxyNAJjgMl6CMw7UszsKNuUCZFIEWtl92gtPl8YgDjo:1tKtsU:tgkKRSDGILBKjBVhxO-9GMHS5juBRdF9PyraYfdm9VE', '2024-12-24 06:37:50.510469');
INSERT INTO `django_session` VALUES ('iy8430jjkrha99j6xh45wwg7w8pmz7gr', '.eJxVjEEOwiAURO_C2hAqfEJduvcM5MOAVA1NSrsy3t2SdKGL2cx7M2_heVuL31pa_ARxEYM4_XaB4zPVDvDgep9lnOu6TEF2RR60yduM9Loe7t9B4Vb6-mzZuETIFLNxAIxyNAJjgMl6CMw7UszsKNuUCZFIEWtl92gtPl8YgDjo:1tKzbH:fG_eWyCyFi-m_Vd9o4lj_GkZUtQd6zeRtRFSaXSKlsI', '2024-12-24 12:44:27.545502');
INSERT INTO `django_session` VALUES ('lv4qtkqg1lit8885x45hkms7vjs8inyl', '.eJxVjDEOwjAMRe-SGUUlOHXNyM4Zojh2SAGlUtNOiLtDpQ6w_vfef5kQ16WEtekcRjFnczSH341jemjdgNxjvU02TXWZR7abYnfa7HUSfV529--gxFa-dQeOFSlnQvB8QvUOO845Ow-k6jkKA1OPSt4NHnvgIUUAQQJRIvP-AOj1OAY:1tKTyS:YIwlKaBJ_MWtff9Zd_u4YCTWjzTyWsrB57dEK71hjgQ', '2024-12-23 02:58:16.269742');
INSERT INTO `django_session` VALUES ('lx4iwn3llt035c9ztfaldgm311vpw3w3', '.eJxVjDsOwjAQBe_iGln-xcaU9DmDtd5d4wBypDipEHeHSCmgfTPzXiLBtta0dV7SROIinDj9bhnwwW0HdId2myXObV2mLHdFHrTLcSZ-Xg_376BCr986DKhBcSTrWFvA4JmM8oGA0WFmLDlGyN5qoGDPBVAXpzQaGMAaE8T7Aw0bONg:1tKeVq:NxO8vvL2xXDATR9uW-ly14DsCkVTcCRMX2jtPzq4uM0', '2024-12-23 14:13:26.346681');
INSERT INTO `django_session` VALUES ('mz4cs56l99s77fz11413mcj9u43hyxpf', '.eJxVjDEOwjAMRe-SGUUlOHXNyM4Zojh2SAGlUtNOiLtDpQ6w_vfef5kQ16WEtekcRjFnczSH341jemjdgNxjvU02TXWZR7abYnfa7HUSfV529--gxFa-dQeOFSlnQvB8QvUOO845Ow-k6jkKA1OPSt4NHnvgIUUAQQJRIvP-AOj1OAY:1tKJiA:CKIMQMLSdnuYg1zfnH97i1PlC3XUCOezztJS6e0o460', '2024-12-22 16:00:46.673716');
INSERT INTO `django_session` VALUES ('oxsczshs209q2dbtrk4s5gk08u35nt3s', '.eJxVjEEOwiAURO_C2hAqfEJduvcM5MOAVA1NSrsy3t2SdKGL2cx7M2_heVuL31pa_ARxEYM4_XaB4zPVDvDgep9lnOu6TEF2RR60yduM9Loe7t9B4Vb6-mzZuETIFLNxAIxyNAJjgMl6CMw7UszsKNuUCZFIEWtl92gtPl8YgDjo:1tKeWZ:hOb4984YZbWADpDnzVPkNf52dWilL2afwFjILGiX8Rk', '2024-12-23 14:14:11.478097');
INSERT INTO `django_session` VALUES ('pagdmqgt3p3eevcm49lu3z1tz9hgdhzu', '.eJxVjEEOwiAURO_C2hAqfEJduvcM5MOAVA1NSrsy3t2SdKGL2cx7M2_heVuL31pa_ARxEYM4_XaB4zPVDvDgep9lnOu6TEF2RR60yduM9Loe7t9B4Vb6-mzZuETIFLNxAIxyNAJjgMl6CMw7UszsKNuUCZFIEWtl92gtPl8YgDjo:1tKtoR:gk4XOPblin6YIFnYVmRyUIgOVJWLq9EHyxbRsWurtLM', '2024-12-24 06:33:39.179657');
INSERT INTO `django_session` VALUES ('rgnhebjnf8hglp9ab3exgdyunr67shw6', '.eJxVjEEOwiAURO_C2hAqfEJduvcM5MOAVA1NSrsy3t2SdKGL2cx7M2_heVuL31pa_ARxEYM4_XaB4zPVDvDgep9lnOu6TEF2RR60yduM9Loe7t9B4Vb6-mzZuETIFLNxAIxyNAJjgMl6CMw7UszsKNuUCZFIEWtl92gtPl8YgDjo:1tKqMr:xKBE63dq_zkyYZTdX33trBlWecQJs8m0TxENDuVLcuw', '2024-12-24 02:52:57.309808');
INSERT INTO `django_session` VALUES ('rwezcz99rwzhl61icjazp4jpwkdstzc6', '.eJxVjMEOwiAQRP-FsyEsLVA8eu83kIVlpWpoUtqT8d9tkx70Npn3Zt4i4LaWsLW8hInEVRhx-e0ipmeuB6AH1vss01zXZYryUORJmxxnyq_b6f4dFGxlX1uA6CAbxQysHXhIfQSkBMqysuQs7RmAYx6MZt37ZLzVCpXuOjcY8fkC2i83Lw:1tKfZj:g9afDVT67V0y8AQ4uozXfVYV1RT4OSlh-mi_2V5BU18', '2024-12-23 15:21:31.168347');
INSERT INTO `django_session` VALUES ('s7mi49cbaow68eb32j3qa5elh9wi9fkb', '.eJxVjMEOwiAQRP-FsyEsLVA8eu83kIVlpWpoUtqT8d9tkx70Npn3Zt4i4LaWsLW8hInEVRhx-e0ipmeuB6AH1vss01zXZYryUORJmxxnyq_b6f4dFGxlX1uA6CAbxQysHXhIfQSkBMqysuQs7RmAYx6MZt37ZLzVCpXuOjcY8fkC2i83Lw:1tKfV8:wUob8r8BjKL1PABcxZDXOb8BOf_Faocw5kajRnWkdIY', '2024-12-23 15:16:46.205188');
INSERT INTO `django_session` VALUES ('twckldicd055ehj5v1avqi7fq1y25cp6', '.eJxVjMEOwiAQRP-FsyEsLVA8eu83kIVlpWpoUtqT8d9tkx70Npn3Zt4i4LaWsLW8hInEVRhx-e0ipmeuB6AH1vss01zXZYryUORJmxxnyq_b6f4dFGxlX1uA6CAbxQysHXhIfQSkBMqysuQs7RmAYx6MZt37ZLzVCpXuOjcY8fkC2i83Lw:1tKfcw:ebs08PR8WwVPq_F1dGsNwkok3qnOpxH22kS18A9c9-Q', '2024-12-23 15:24:50.201896');
INSERT INTO `django_session` VALUES ('u62n93wxs34sn2921wyycafifttuaole', '.eJxVjDsOwjAQBe_iGln-xcaU9DmDtd5d4wBypDipEHeHSCmgfTPzXiLBtta0dV7SROIinDj9bhnwwW0HdId2myXObV2mLHdFHrTLcSZ-Xg_376BCr986DKhBcSTrWFvA4JmM8oGA0WFmLDlGyN5qoGDPBVAXpzQaGMAaE8T7Aw0bONg:1tKtrG:igNAdDouUlpbz14lGieoPQNu0AP4E_IdNKi9jwAczt0', '2024-12-24 06:36:34.574486');
INSERT INTO `django_session` VALUES ('v294zv7hg8jynx9u5eato00i669irgyo', '.eJxVjDEOwjAMRe-SGUUlOHXNyM4Zojh2SAGlUtNOiLtDpQ6w_vfef5kQ16WEtekcRjFnczSH341jemjdgNxjvU02TXWZR7abYnfa7HUSfV529--gxFa-dQeOFSlnQvB8QvUOO845Ow-k6jkKA1OPSt4NHnvgIUUAQQJRIvP-AOj1OAY:1tKJhj:E8KIiyxXuT5O2OB0ewxTSfT7OlCEAHvRUpltR8DeEr8', '2024-12-22 16:00:19.198433');
INSERT INTO `django_session` VALUES ('vrbo0jsc0977ox70r2n0f1oeylk5axi5', '.eJxVjEEOwiAURO_C2hAqfEJduvcM5MOAVA1NSrsy3t2SdKGL2cx7M2_heVuL31pa_ARxEYM4_XaB4zPVDvDgep9lnOu6TEF2RR60yduM9Loe7t9B4Vb6-mzZuETIFLNxAIxyNAJjgMl6CMw7UszsKNuUCZFIEWtl92gtPl8YgDjo:1tKzBj:LzMVkvEng9jbBnm0_cPawL43j4FolPl_er8uhFdXHFY', '2024-12-24 12:18:03.442613');
INSERT INTO `django_session` VALUES ('w676zwxi3jwamdq9pasxtxydawc1gqha', '.eJxVjEEOwiAURO_C2hAqfEJduvcM5MOAVA1NSrsy3t2SdKGL2cx7M2_heVuL31pa_ARxEYM4_XaB4zPVDvDgep9lnOu6TEF2RR60yduM9Loe7t9B4Vb6-mzZuETIFLNxAIxyNAJjgMl6CMw7UszsKNuUCZFIEWtl92gtPl8YgDjo:1tKrAC:S_1aCHssHM59XmI8vBTyaZSsOfoJnvnJFBOLdJf2u7k', '2024-12-24 03:43:56.733756');
INSERT INTO `django_session` VALUES ('wpwyz8k8zu9xrgkgvy6kooiqup1517d3', '.eJxVjDEOwjAMRe-SGUUlOHXNyM4Zojh2SAGlUtNOiLtDpQ6w_vfef5kQ16WEtekcRjFnczSH341jemjdgNxjvU02TXWZR7abYnfa7HUSfV529--gxFa-dQeOFSlnQvB8QvUOO845Ow-k6jkKA1OPSt4NHnvgIUUAQQJRIvP-AOj1OAY:1tKUAd:By-p9rMG6v23vtsVj5f9JI4GmeB4-8CrmUYXuoHY4Q0', '2024-12-23 03:10:51.082098');

-- ----------------------------
-- Table structure for notifications_historicalnotification
-- ----------------------------
DROP TABLE IF EXISTS `notifications_historicalnotification`;
CREATE TABLE `notifications_historicalnotification`  (
  `id` bigint NOT NULL,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `error_message` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `scheduled_time` datetime(6) NULL DEFAULT NULL,
  `sent_time` datetime(6) NULL DEFAULT NULL,
  `read_time` datetime(6) NULL DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `history_id` int NOT NULL AUTO_INCREMENT,
  `history_date` datetime(6) NOT NULL,
  `history_change_reason` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `history_type` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `history_user_id` bigint NULL DEFAULT NULL,
  `user_id` bigint NULL DEFAULT NULL,
  `template_id` bigint NULL DEFAULT NULL,
  PRIMARY KEY (`history_id`) USING BTREE,
  INDEX `notifications_histor_history_user_id_57363846_fk_accounts_`(`history_user_id` ASC) USING BTREE,
  INDEX `notifications_historicalnotification_id_d656930b`(`id` ASC) USING BTREE,
  INDEX `notifications_historicalnotification_history_date_fea30a6e`(`history_date` ASC) USING BTREE,
  INDEX `notifications_historicalnotification_user_id_4ad56ffd`(`user_id` ASC) USING BTREE,
  INDEX `notifications_historicalnotification_template_id_7c5ccaf8`(`template_id` ASC) USING BTREE,
  CONSTRAINT `notifications_histor_history_user_id_57363846_fk_accounts_` FOREIGN KEY (`history_user_id`) REFERENCES `accounts_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of notifications_historicalnotification
-- ----------------------------

-- ----------------------------
-- Table structure for notifications_historicalnotificationdevice
-- ----------------------------
DROP TABLE IF EXISTS `notifications_historicalnotificationdevice`;
CREATE TABLE `notifications_historicalnotificationdevice`  (
  `id` bigint NOT NULL,
  `push_token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `is_enabled` tinyint(1) NOT NULL,
  `last_active` datetime(6) NULL DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `history_id` int NOT NULL AUTO_INCREMENT,
  `history_date` datetime(6) NOT NULL,
  `history_change_reason` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `history_type` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `device_id` bigint NULL DEFAULT NULL,
  `history_user_id` bigint NULL DEFAULT NULL,
  `user_id` bigint NULL DEFAULT NULL,
  PRIMARY KEY (`history_id`) USING BTREE,
  INDEX `notifications_histor_history_user_id_ec4ec2f0_fk_accounts_`(`history_user_id` ASC) USING BTREE,
  INDEX `notifications_historicalnotificationdevice_id_b6cf790e`(`id` ASC) USING BTREE,
  INDEX `notifications_historicalnotificationdevice_history_date_0dad2fb1`(`history_date` ASC) USING BTREE,
  INDEX `notifications_historicalnotificationdevice_device_id_2c55af92`(`device_id` ASC) USING BTREE,
  INDEX `notifications_historicalnotificationdevice_user_id_04b5bde4`(`user_id` ASC) USING BTREE,
  CONSTRAINT `notifications_histor_history_user_id_ec4ec2f0_fk_accounts_` FOREIGN KEY (`history_user_id`) REFERENCES `accounts_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of notifications_historicalnotificationdevice
-- ----------------------------

-- ----------------------------
-- Table structure for notifications_historicalnotificationtemplate
-- ----------------------------
DROP TABLE IF EXISTS `notifications_historicalnotificationtemplate`;
CREATE TABLE `notifications_historicalnotificationtemplate`  (
  `id` bigint NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `title_template` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content_template` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `history_id` int NOT NULL AUTO_INCREMENT,
  `history_date` datetime(6) NOT NULL,
  `history_change_reason` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `history_type` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `history_user_id` bigint NULL DEFAULT NULL,
  PRIMARY KEY (`history_id`) USING BTREE,
  INDEX `notifications_histor_history_user_id_8273335b_fk_accounts_`(`history_user_id` ASC) USING BTREE,
  INDEX `notifications_historicalnotificationtemplate_id_c9981f8c`(`id` ASC) USING BTREE,
  INDEX `notifications_historicalnot_history_date_3cb18f7e`(`history_date` ASC) USING BTREE,
  CONSTRAINT `notifications_histor_history_user_id_8273335b_fk_accounts_` FOREIGN KEY (`history_user_id`) REFERENCES `accounts_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of notifications_historicalnotificationtemplate
-- ----------------------------

-- ----------------------------
-- Table structure for notifications_notification
-- ----------------------------
DROP TABLE IF EXISTS `notifications_notification`;
CREATE TABLE `notifications_notification`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `error_message` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `scheduled_time` datetime(6) NULL DEFAULT NULL,
  `sent_time` datetime(6) NULL DEFAULT NULL,
  `read_time` datetime(6) NULL DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `user_id` bigint NOT NULL,
  `template_id` bigint NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `notifications_notification_user_id_b5e8c0ff_fk_accounts_user_id`(`user_id` ASC) USING BTREE,
  INDEX `notifications_notifi_template_id_4027a99c_fk_notificat`(`template_id` ASC) USING BTREE,
  CONSTRAINT `notifications_notifi_template_id_4027a99c_fk_notificat` FOREIGN KEY (`template_id`) REFERENCES `notifications_notificationtemplate` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `notifications_notification_user_id_b5e8c0ff_fk_accounts_user_id` FOREIGN KEY (`user_id`) REFERENCES `accounts_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of notifications_notification
-- ----------------------------

-- ----------------------------
-- Table structure for notifications_notificationdevice
-- ----------------------------
DROP TABLE IF EXISTS `notifications_notificationdevice`;
CREATE TABLE `notifications_notificationdevice`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `push_token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `is_enabled` tinyint(1) NOT NULL,
  `last_active` datetime(6) NULL DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `device_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `notifications_notificationdevice_user_id_device_id_d8878dcf_uniq`(`user_id` ASC, `device_id` ASC) USING BTREE,
  INDEX `notifications_notifi_device_id_55e3885a_fk_accounts_`(`device_id` ASC) USING BTREE,
  CONSTRAINT `notifications_notifi_device_id_55e3885a_fk_accounts_` FOREIGN KEY (`device_id`) REFERENCES `accounts_userdevice` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `notifications_notifi_user_id_8200c980_fk_accounts_` FOREIGN KEY (`user_id`) REFERENCES `accounts_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of notifications_notificationdevice
-- ----------------------------

-- ----------------------------
-- Table structure for notifications_notificationtemplate
-- ----------------------------
DROP TABLE IF EXISTS `notifications_notificationtemplate`;
CREATE TABLE `notifications_notificationtemplate`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `title_template` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content_template` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of notifications_notificationtemplate
-- ----------------------------

-- ----------------------------
-- Table structure for oauth2_provider_accesstoken
-- ----------------------------
DROP TABLE IF EXISTS `oauth2_provider_accesstoken`;
CREATE TABLE `oauth2_provider_accesstoken`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `expires` datetime(6) NOT NULL,
  `scope` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `application_id` bigint NULL DEFAULT NULL,
  `user_id` bigint NULL DEFAULT NULL,
  `created` datetime(6) NOT NULL,
  `updated` datetime(6) NOT NULL,
  `source_refresh_token_id` bigint NULL DEFAULT NULL,
  `id_token_id` bigint NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `token`(`token` ASC) USING BTREE,
  UNIQUE INDEX `source_refresh_token_id`(`source_refresh_token_id` ASC) USING BTREE,
  UNIQUE INDEX `id_token_id`(`id_token_id` ASC) USING BTREE,
  INDEX `oauth2_provider_acce_application_id_b22886e1_fk_oauth2_pr`(`application_id` ASC) USING BTREE,
  INDEX `oauth2_provider_accesstoken_user_id_6e4c9a65_fk_accounts_user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `oauth2_provider_acce_application_id_b22886e1_fk_oauth2_pr` FOREIGN KEY (`application_id`) REFERENCES `oauth2_provider_application` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `oauth2_provider_acce_id_token_id_85db651b_fk_oauth2_pr` FOREIGN KEY (`id_token_id`) REFERENCES `oauth2_provider_idtoken` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `oauth2_provider_acce_source_refresh_token_e66fbc72_fk_oauth2_pr` FOREIGN KEY (`source_refresh_token_id`) REFERENCES `oauth2_provider_refreshtoken` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `oauth2_provider_accesstoken_user_id_6e4c9a65_fk_accounts_user_id` FOREIGN KEY (`user_id`) REFERENCES `accounts_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oauth2_provider_accesstoken
-- ----------------------------

-- ----------------------------
-- Table structure for oauth2_provider_application
-- ----------------------------
DROP TABLE IF EXISTS `oauth2_provider_application`;
CREATE TABLE `oauth2_provider_application`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `client_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `redirect_uris` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `client_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `authorization_grant_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `client_secret` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `user_id` bigint NULL DEFAULT NULL,
  `skip_authorization` tinyint(1) NOT NULL,
  `created` datetime(6) NOT NULL,
  `updated` datetime(6) NOT NULL,
  `algorithm` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `post_logout_redirect_uris` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `client_id`(`client_id` ASC) USING BTREE,
  INDEX `oauth2_provider_application_user_id_79829054_fk_accounts_user_id`(`user_id` ASC) USING BTREE,
  INDEX `oauth2_provider_application_client_secret_53133678`(`client_secret` ASC) USING BTREE,
  CONSTRAINT `oauth2_provider_application_user_id_79829054_fk_accounts_user_id` FOREIGN KEY (`user_id`) REFERENCES `accounts_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oauth2_provider_application
-- ----------------------------

-- ----------------------------
-- Table structure for oauth2_provider_grant
-- ----------------------------
DROP TABLE IF EXISTS `oauth2_provider_grant`;
CREATE TABLE `oauth2_provider_grant`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `expires` datetime(6) NOT NULL,
  `redirect_uri` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `scope` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `application_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `created` datetime(6) NOT NULL,
  `updated` datetime(6) NOT NULL,
  `code_challenge` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `code_challenge_method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `nonce` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `claims` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `code`(`code` ASC) USING BTREE,
  INDEX `oauth2_provider_gran_application_id_81923564_fk_oauth2_pr`(`application_id` ASC) USING BTREE,
  INDEX `oauth2_provider_grant_user_id_e8f62af8_fk_accounts_user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `oauth2_provider_gran_application_id_81923564_fk_oauth2_pr` FOREIGN KEY (`application_id`) REFERENCES `oauth2_provider_application` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `oauth2_provider_grant_user_id_e8f62af8_fk_accounts_user_id` FOREIGN KEY (`user_id`) REFERENCES `accounts_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oauth2_provider_grant
-- ----------------------------

-- ----------------------------
-- Table structure for oauth2_provider_idtoken
-- ----------------------------
DROP TABLE IF EXISTS `oauth2_provider_idtoken`;
CREATE TABLE `oauth2_provider_idtoken`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `jti` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `expires` datetime(6) NOT NULL,
  `scope` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `created` datetime(6) NOT NULL,
  `updated` datetime(6) NOT NULL,
  `application_id` bigint NULL DEFAULT NULL,
  `user_id` bigint NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `jti`(`jti` ASC) USING BTREE,
  INDEX `oauth2_provider_idto_application_id_08c5ff4f_fk_oauth2_pr`(`application_id` ASC) USING BTREE,
  INDEX `oauth2_provider_idtoken_user_id_dd512b59_fk_accounts_user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `oauth2_provider_idto_application_id_08c5ff4f_fk_oauth2_pr` FOREIGN KEY (`application_id`) REFERENCES `oauth2_provider_application` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `oauth2_provider_idtoken_user_id_dd512b59_fk_accounts_user_id` FOREIGN KEY (`user_id`) REFERENCES `accounts_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oauth2_provider_idtoken
-- ----------------------------

-- ----------------------------
-- Table structure for oauth2_provider_refreshtoken
-- ----------------------------
DROP TABLE IF EXISTS `oauth2_provider_refreshtoken`;
CREATE TABLE `oauth2_provider_refreshtoken`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `access_token_id` bigint NULL DEFAULT NULL,
  `application_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `created` datetime(6) NOT NULL,
  `updated` datetime(6) NOT NULL,
  `revoked` datetime(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `access_token_id`(`access_token_id` ASC) USING BTREE,
  UNIQUE INDEX `oauth2_provider_refreshtoken_token_revoked_af8a5134_uniq`(`token` ASC, `revoked` ASC) USING BTREE,
  INDEX `oauth2_provider_refr_application_id_2d1c311b_fk_oauth2_pr`(`application_id` ASC) USING BTREE,
  INDEX `oauth2_provider_refr_user_id_da837fce_fk_accounts_`(`user_id` ASC) USING BTREE,
  CONSTRAINT `oauth2_provider_refr_access_token_id_775e84e8_fk_oauth2_pr` FOREIGN KEY (`access_token_id`) REFERENCES `oauth2_provider_accesstoken` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `oauth2_provider_refr_application_id_2d1c311b_fk_oauth2_pr` FOREIGN KEY (`application_id`) REFERENCES `oauth2_provider_application` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `oauth2_provider_refr_user_id_da837fce_fk_accounts_` FOREIGN KEY (`user_id`) REFERENCES `accounts_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oauth2_provider_refreshtoken
-- ----------------------------

-- ----------------------------
-- Table structure for social_auth_association
-- ----------------------------
DROP TABLE IF EXISTS `social_auth_association`;
CREATE TABLE `social_auth_association`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `server_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `handle` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `secret` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `issued` int NOT NULL,
  `lifetime` int NOT NULL,
  `assoc_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `social_auth_association_server_url_handle_078befa2_uniq`(`server_url` ASC, `handle` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of social_auth_association
-- ----------------------------

-- ----------------------------
-- Table structure for social_auth_code
-- ----------------------------
DROP TABLE IF EXISTS `social_auth_code`;
CREATE TABLE `social_auth_code`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `email` varchar(254) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `verified` tinyint(1) NOT NULL,
  `timestamp` datetime(6) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `social_auth_code_email_code_801b2d02_uniq`(`email` ASC, `code` ASC) USING BTREE,
  INDEX `social_auth_code_code_a2393167`(`code` ASC) USING BTREE,
  INDEX `social_auth_code_timestamp_176b341f`(`timestamp` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of social_auth_code
-- ----------------------------

-- ----------------------------
-- Table structure for social_auth_nonce
-- ----------------------------
DROP TABLE IF EXISTS `social_auth_nonce`;
CREATE TABLE `social_auth_nonce`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `server_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `timestamp` int NOT NULL,
  `salt` varchar(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `social_auth_nonce_server_url_timestamp_salt_f6284463_uniq`(`server_url` ASC, `timestamp` ASC, `salt` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of social_auth_nonce
-- ----------------------------

-- ----------------------------
-- Table structure for social_auth_partial
-- ----------------------------
DROP TABLE IF EXISTS `social_auth_partial`;
CREATE TABLE `social_auth_partial`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `token` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `next_step` smallint UNSIGNED NOT NULL,
  `backend` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `timestamp` datetime(6) NOT NULL,
  `data` json NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `social_auth_partial_token_3017fea3`(`token` ASC) USING BTREE,
  INDEX `social_auth_partial_timestamp_50f2119f`(`timestamp` ASC) USING BTREE,
  CONSTRAINT `social_auth_partial_chk_1` CHECK (`next_step` >= 0)
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of social_auth_partial
-- ----------------------------

-- ----------------------------
-- Table structure for social_auth_usersocialauth
-- ----------------------------
DROP TABLE IF EXISTS `social_auth_usersocialauth`;
CREATE TABLE `social_auth_usersocialauth`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `provider` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `user_id` bigint NOT NULL,
  `created` datetime(6) NOT NULL,
  `modified` datetime(6) NOT NULL,
  `extra_data` json NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `social_auth_usersocialauth_provider_uid_e6b5e668_uniq`(`provider` ASC, `uid` ASC) USING BTREE,
  INDEX `social_auth_usersocialauth_user_id_17d28448_fk_accounts_user_id`(`user_id` ASC) USING BTREE,
  INDEX `social_auth_usersocialauth_uid_796e51dc`(`uid` ASC) USING BTREE,
  CONSTRAINT `social_auth_usersocialauth_user_id_17d28448_fk_accounts_user_id` FOREIGN KEY (`user_id`) REFERENCES `accounts_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of social_auth_usersocialauth
-- ----------------------------

-- ----------------------------
-- Table structure for tasks_category
-- ----------------------------
DROP TABLE IF EXISTS `tasks_category`;
CREATE TABLE `tasks_category`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `color` varchar(7) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `icon` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `order` int NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `tasks_category_user_id_name_179a46a2_uniq`(`user_id` ASC, `name` ASC) USING BTREE,
  CONSTRAINT `tasks_category_user_id_8db0a286_fk_accounts_user_id` FOREIGN KEY (`user_id`) REFERENCES `accounts_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tasks_category
-- ----------------------------
INSERT INTO `tasks_category` VALUES (1, '1212', '#1890ff', 'icon-work', 0, '2024-12-09 03:57:50.571084', '2024-12-09 03:57:50.571084', 2);
INSERT INTO `tasks_category` VALUES (2, '学习', '#3357FF', 'study', 3, '2024-12-09 06:05:05.942868', '2024-12-09 06:05:05.942868', 1);
INSERT INTO `tasks_category` VALUES (5, '学习2', '#3357FF', 'study', 3, '2024-12-09 06:09:29.886175', '2024-12-09 06:09:29.886175', 2);
INSERT INTO `tasks_category` VALUES (6, '学习2222', '#3357FF', 'study', 3, '2024-12-09 07:24:56.105881', '2024-12-09 07:24:56.105881', 1);
INSERT INTO `tasks_category` VALUES (7, '学习22111122', '#3357FF', 'study', 3, '2024-12-09 07:25:37.970069', '2024-12-09 07:25:37.970069', 1);
INSERT INTO `tasks_category` VALUES (8, '学333习22111122', '#3357FF', 'study', 3, '2024-12-09 07:26:20.122245', '2024-12-09 07:26:20.122245', 1);
INSERT INTO `tasks_category` VALUES (9, '学习12133123', '#3357FF', 'study', 3, '2024-12-09 07:27:08.189447', '2024-12-09 07:27:08.189447', 1);
INSERT INTO `tasks_category` VALUES (10, '学111习', '#3357FF', 'study', 3, '2024-12-09 08:10:32.156864', '2024-12-09 08:10:32.157872', 1);
INSERT INTO `tasks_category` VALUES (11, '学11221习', '#3357FF', 'study', 3, '2024-12-09 08:11:44.965993', '2024-12-09 08:11:44.965993', 1);
INSERT INTO `tasks_category` VALUES (12, '学11221习22', '#3357FF', 'study', 3, '2024-12-09 08:13:14.227493', '2024-12-09 08:13:14.227493', 1);
INSERT INTO `tasks_category` VALUES (13, '学1111习', '#3357FF', 'study', 3, '2024-12-09 08:19:59.801049', '2024-12-09 08:19:59.801049', 1);
INSERT INTO `tasks_category` VALUES (14, '学习', '#3357FF', 'study', 3, '2024-12-09 12:44:06.291793', '2024-12-09 12:44:06.291793', 4);
INSERT INTO `tasks_category` VALUES (15, '学习2', '#3357FF', 'study', 3, '2024-12-09 12:44:19.098337', '2024-12-09 12:44:19.098337', 4);
INSERT INTO `tasks_category` VALUES (16, '学习2222', '#3357FF', 'study', 3, '2024-12-09 12:45:15.556651', '2024-12-09 12:45:15.556651', 4);
INSERT INTO `tasks_category` VALUES (17, '111', '#13c2c2', '21312313', 0, '2024-12-09 15:24:10.151171', '2024-12-09 15:24:10.151171', 5);

-- ----------------------------
-- Table structure for tasks_historicalcategory
-- ----------------------------
DROP TABLE IF EXISTS `tasks_historicalcategory`;
CREATE TABLE `tasks_historicalcategory`  (
  `id` bigint NOT NULL,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `color` varchar(7) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `icon` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `order` int NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `history_id` int NOT NULL AUTO_INCREMENT,
  `history_date` datetime(6) NOT NULL,
  `history_change_reason` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `history_type` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `history_user_id` bigint NULL DEFAULT NULL,
  `user_id` bigint NULL DEFAULT NULL,
  PRIMARY KEY (`history_id`) USING BTREE,
  INDEX `tasks_historicalcate_history_user_id_79c18336_fk_accounts_`(`history_user_id` ASC) USING BTREE,
  INDEX `tasks_historicalcategory_id_9a36d53a`(`id` ASC) USING BTREE,
  INDEX `tasks_historicalcategory_history_date_7e3a3361`(`history_date` ASC) USING BTREE,
  INDEX `tasks_historicalcategory_user_id_debf2c6b`(`user_id` ASC) USING BTREE,
  CONSTRAINT `tasks_historicalcate_history_user_id_79c18336_fk_accounts_` FOREIGN KEY (`history_user_id`) REFERENCES `accounts_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tasks_historicalcategory
-- ----------------------------
INSERT INTO `tasks_historicalcategory` VALUES (1, '1212', '#1890ff', 'icon-work', 0, '2024-12-09 03:57:50.571084', '2024-12-09 03:57:50.571084', 1, '2024-12-09 03:57:50.574401', NULL, '+', 1, 1);
INSERT INTO `tasks_historicalcategory` VALUES (2, '学习', '#3357FF', 'study', 3, '2024-12-09 06:05:05.942868', '2024-12-09 06:05:05.942868', 2, '2024-12-09 06:05:05.950627', NULL, '+', 1, 1);
INSERT INTO `tasks_historicalcategory` VALUES (3, '学习', '#3357FF', 'study', 3, '2024-12-09 06:05:12.481552', '2024-12-09 06:05:12.481552', 3, '2024-12-09 06:05:12.486419', NULL, '+', 1, 1);
INSERT INTO `tasks_historicalcategory` VALUES (4, '学习', '#3357FF', 'study', 3, '2024-12-09 06:05:15.174051', '2024-12-09 06:05:15.174051', 4, '2024-12-09 06:05:15.175448', NULL, '+', 1, 1);
INSERT INTO `tasks_historicalcategory` VALUES (5, '学习2', '#3357FF', 'study', 3, '2024-12-09 06:09:29.886175', '2024-12-09 06:09:29.886175', 5, '2024-12-09 06:09:29.887964', NULL, '+', 1, 1);
INSERT INTO `tasks_historicalcategory` VALUES (6, '学习2222', '#3357FF', 'study', 3, '2024-12-09 07:24:56.105881', '2024-12-09 07:24:56.105881', 6, '2024-12-09 07:24:56.112516', NULL, '+', 1, 1);
INSERT INTO `tasks_historicalcategory` VALUES (7, '学习22111122', '#3357FF', 'study', 3, '2024-12-09 07:25:37.970069', '2024-12-09 07:25:37.970069', 7, '2024-12-09 07:25:37.974863', NULL, '+', 1, 1);
INSERT INTO `tasks_historicalcategory` VALUES (8, '学333习22111122', '#3357FF', 'study', 3, '2024-12-09 07:26:20.122245', '2024-12-09 07:26:20.122245', 8, '2024-12-09 07:26:20.130033', NULL, '+', 1, 1);
INSERT INTO `tasks_historicalcategory` VALUES (9, '学习12133123', '#3357FF', 'study', 3, '2024-12-09 07:27:08.189447', '2024-12-09 07:27:08.189447', 9, '2024-12-09 07:27:08.193706', NULL, '+', 1, 1);
INSERT INTO `tasks_historicalcategory` VALUES (10, '学111习', '#3357FF', 'study', 3, '2024-12-09 08:10:32.156864', '2024-12-09 08:10:32.157872', 10, '2024-12-09 08:10:32.158862', NULL, '+', 1, 1);
INSERT INTO `tasks_historicalcategory` VALUES (11, '学11221习', '#3357FF', 'study', 3, '2024-12-09 08:11:44.965993', '2024-12-09 08:11:44.965993', 11, '2024-12-09 08:11:44.969705', NULL, '+', 1, 1);
INSERT INTO `tasks_historicalcategory` VALUES (12, '学11221习22', '#3357FF', 'study', 3, '2024-12-09 08:13:14.227493', '2024-12-09 08:13:14.227493', 12, '2024-12-09 08:13:14.235287', NULL, '+', 1, 1);
INSERT INTO `tasks_historicalcategory` VALUES (13, '学1111习', '#3357FF', 'study', 3, '2024-12-09 08:19:59.801049', '2024-12-09 08:19:59.801049', 13, '2024-12-09 08:19:59.802553', NULL, '+', 1, 1);
INSERT INTO `tasks_historicalcategory` VALUES (4, '学习', '#3357FF', 'study', 3, '2024-12-09 06:05:15.174051', '2024-12-09 06:05:15.174051', 14, '2024-12-09 08:26:13.368068', NULL, '-', NULL, 1);
INSERT INTO `tasks_historicalcategory` VALUES (3, '学习', '#3357FF', 'study', 3, '2024-12-09 06:05:12.481552', '2024-12-09 06:05:12.481552', 15, '2024-12-09 08:26:13.369070', NULL, '-', NULL, 1);
INSERT INTO `tasks_historicalcategory` VALUES (14, '学习', '#3357FF', 'study', 3, '2024-12-09 12:44:06.291793', '2024-12-09 12:44:06.291793', 16, '2024-12-09 12:44:06.294793', NULL, '+', 4, 4);
INSERT INTO `tasks_historicalcategory` VALUES (15, '学习2', '#3357FF', 'study', 3, '2024-12-09 12:44:19.098337', '2024-12-09 12:44:19.098337', 17, '2024-12-09 12:44:19.102131', NULL, '+', 4, 4);
INSERT INTO `tasks_historicalcategory` VALUES (16, '学习2222', '#3357FF', 'study', 3, '2024-12-09 12:45:15.556651', '2024-12-09 12:45:15.556651', 18, '2024-12-09 12:45:15.560931', NULL, '+', 4, 4);
INSERT INTO `tasks_historicalcategory` VALUES (17, '111', '#13c2c2', '21312313', 0, '2024-12-09 15:24:10.151171', '2024-12-09 15:24:10.151171', 19, '2024-12-09 15:24:10.152682', NULL, '+', 5, 5);

-- ----------------------------
-- Table structure for tasks_historicaltag
-- ----------------------------
DROP TABLE IF EXISTS `tasks_historicaltag`;
CREATE TABLE `tasks_historicaltag`  (
  `id` bigint NOT NULL,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `color` varchar(7) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `history_id` int NOT NULL AUTO_INCREMENT,
  `history_date` datetime(6) NOT NULL,
  `history_change_reason` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `history_type` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `history_user_id` bigint NULL DEFAULT NULL,
  `user_id` bigint NULL DEFAULT NULL,
  PRIMARY KEY (`history_id`) USING BTREE,
  INDEX `tasks_historicaltag_history_user_id_655d7d00_fk_accounts_user_id`(`history_user_id` ASC) USING BTREE,
  INDEX `tasks_historicaltag_id_18ede4b5`(`id` ASC) USING BTREE,
  INDEX `tasks_historicaltag_history_date_0c35d69f`(`history_date` ASC) USING BTREE,
  INDEX `tasks_historicaltag_user_id_55fe0b9c`(`user_id` ASC) USING BTREE,
  CONSTRAINT `tasks_historicaltag_history_user_id_655d7d00_fk_accounts_user_id` FOREIGN KEY (`history_user_id`) REFERENCES `accounts_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tasks_historicaltag
-- ----------------------------
INSERT INTO `tasks_historicaltag` VALUES (1, '个人', '#0033FF', '2024-12-09 12:46:10.889522', '2024-12-09 12:46:10.889522', 1, '2024-12-09 12:46:10.893598', NULL, '+', 4, 4);
INSERT INTO `tasks_historicaltag` VALUES (3, '个人1', '#0033FF', '2024-12-09 12:48:33.417726', '2024-12-09 12:48:33.417726', 2, '2024-12-09 12:48:33.418726', NULL, '+', 4, 4);

-- ----------------------------
-- Table structure for tasks_historicaltask
-- ----------------------------
DROP TABLE IF EXISTS `tasks_historicaltask`;
CREATE TABLE `tasks_historicaltask`  (
  `id` bigint NOT NULL,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `priority` int NOT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `due_date` datetime(6) NULL DEFAULT NULL,
  `reminder_time` datetime(6) NULL DEFAULT NULL,
  `repeat_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `repeat_config` json NULL,
  `completed_at` datetime(6) NULL DEFAULT NULL,
  `is_important` tinyint(1) NOT NULL,
  `order` int NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `history_id` int NOT NULL AUTO_INCREMENT,
  `history_date` datetime(6) NOT NULL,
  `history_change_reason` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `history_type` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `category_id` bigint NULL DEFAULT NULL,
  `history_user_id` bigint NULL DEFAULT NULL,
  `user_id` bigint NULL DEFAULT NULL,
  PRIMARY KEY (`history_id`) USING BTREE,
  INDEX `tasks_historicaltask_history_user_id_148c89e8_fk_accounts_`(`history_user_id` ASC) USING BTREE,
  INDEX `tasks_historicaltask_id_f4566092`(`id` ASC) USING BTREE,
  INDEX `tasks_historicaltask_history_date_99005c2a`(`history_date` ASC) USING BTREE,
  INDEX `tasks_historicaltask_category_id_c05ae4ff`(`category_id` ASC) USING BTREE,
  INDEX `tasks_historicaltask_user_id_6f9d29dd`(`user_id` ASC) USING BTREE,
  CONSTRAINT `tasks_historicaltask_history_user_id_148c89e8_fk_accounts_` FOREIGN KEY (`history_user_id`) REFERENCES `accounts_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 182 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tasks_historicaltask
-- ----------------------------
INSERT INTO `tasks_historicaltask` VALUES (1, '准备会议材料', '准备下周一的项目进度会议材料', 1, 'pending', '2024-12-15 14:00:00.000000', NULL, 'none', NULL, NULL, 1, 0, '2024-12-09 12:54:10.202760', '2024-12-09 12:54:10.202760', 1, '2024-12-09 12:54:10.204270', NULL, '+', 1, 4, 4);
INSERT INTO `tasks_historicaltask` VALUES (2, '准备会议材料', '准备下周一的项目进度会议材料', 1, 'pending', '2024-12-15 14:00:00.000000', NULL, 'none', NULL, NULL, 1, 0, '2024-12-09 12:54:26.747825', '2024-12-09 12:54:26.747825', 2, '2024-12-09 12:54:26.757234', NULL, '+', 1, 4, 4);
INSERT INTO `tasks_historicaltask` VALUES (3, '准备会议材料', '准备下周一的项目进度会议材料', 1, 'pending', '2024-12-15 14:00:00.000000', NULL, 'none', NULL, NULL, 1, 0, '2024-12-09 12:54:36.879119', '2024-12-09 12:54:36.879119', 3, '2024-12-09 12:54:36.881118', NULL, '+', 1, 4, 4);
INSERT INTO `tasks_historicaltask` VALUES (4, '准备会议材料', '准备下周一的项目进度会议材料', 1, 'pending', '2024-12-15 14:00:00.000000', NULL, 'none', NULL, NULL, 1, 0, '2024-12-09 12:54:40.977028', '2024-12-09 12:54:40.977028', 4, '2024-12-09 12:54:40.984092', NULL, '+', 1, 4, 4);
INSERT INTO `tasks_historicaltask` VALUES (5, '11', '11', 2, 'pending', '2024-12-20 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 14:41:50.760126', '2024-12-09 14:41:50.760126', 5, '2024-12-09 14:41:50.764715', NULL, '+', 2, 1, 1);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:24:35.021758', 6, '2024-12-09 15:24:35.025626', NULL, '+', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:24:35.283262', 7, '2024-12-09 15:24:35.284254', NULL, '+', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:47:28.866852', 8, '2024-12-09 15:47:28.868606', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:47:31.263173', 9, '2024-12-09 15:47:31.263173', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:47:32.250001', 10, '2024-12-09 15:47:32.252001', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:47:33.061851', 11, '2024-12-09 15:47:33.066807', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:47:33.788737', 12, '2024-12-09 15:47:33.790747', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:47:35.258181', 13, '2024-12-09 15:47:35.259577', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:47:36.096575', 14, '2024-12-09 15:47:36.104546', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:47:36.965824', 15, '2024-12-09 15:47:36.981698', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:47:37.616144', 16, '2024-12-09 15:47:37.619860', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:47:38.661497', 17, '2024-12-09 15:47:38.666039', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:47:39.712032', 18, '2024-12-09 15:47:39.716217', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:47:40.404498', 19, '2024-12-09 15:47:40.405507', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:47:41.287421', 20, '2024-12-09 15:47:41.288980', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:47:41.941579', 21, '2024-12-09 15:47:41.943118', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:47:42.827282', 22, '2024-12-09 15:47:42.831864', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:47:43.476027', 23, '2024-12-09 15:47:43.481240', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:47:44.576026', 24, '2024-12-09 15:47:44.581264', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:47:45.240374', 25, '2024-12-09 15:47:45.240374', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:47:50.010013', 26, '2024-12-09 15:47:50.011000', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:47:51.613186', 27, '2024-12-09 15:47:51.616692', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:47:52.287019', 28, '2024-12-09 15:47:52.291579', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:47:53.055298', 29, '2024-12-09 15:47:53.060904', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:47:54.218158', 30, '2024-12-09 15:47:54.220166', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:47:55.188602', 31, '2024-12-09 15:47:55.193151', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:47:56.039462', 32, '2024-12-09 15:47:56.046388', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:47:57.535688', 33, '2024-12-09 15:47:57.539624', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:48:00.496907', 34, '2024-12-09 15:48:00.498631', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:48:01.231186', 35, '2024-12-09 15:48:01.235784', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:48:01.708484', 36, '2024-12-09 15:48:01.710484', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:48:04.154939', 37, '2024-12-09 15:48:04.158264', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:48:05.018013', 38, '2024-12-09 15:48:05.018013', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:48:05.709522', 39, '2024-12-09 15:48:05.710026', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:48:06.459523', 40, '2024-12-09 15:48:06.461154', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:48:07.363038', 41, '2024-12-09 15:48:07.369240', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:48:08.087538', 42, '2024-12-09 15:48:08.092526', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:48:08.768003', 43, '2024-12-09 15:48:08.770007', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:48:09.453059', 44, '2024-12-09 15:48:09.453059', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:48:10.092090', 45, '2024-12-09 15:48:10.096770', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:48:10.623443', 46, '2024-12-09 15:48:10.624453', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:48:11.151817', 47, '2024-12-09 15:48:11.154339', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:48:12.148012', 48, '2024-12-09 15:48:12.152286', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:48:12.988776', 49, '2024-12-09 15:48:12.993419', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:48:13.811817', 50, '2024-12-09 15:48:13.813339', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:48:14.363031', 51, '2024-12-09 15:48:14.365037', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:48:16.059366', 52, '2024-12-09 15:48:16.061358', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:48:16.768356', 53, '2024-12-09 15:48:16.772743', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:48:17.555579', 54, '2024-12-09 15:48:17.555579', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:48:26.156234', 55, '2024-12-09 15:48:26.159790', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:48:28.636212', 56, '2024-12-09 15:48:28.640793', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:48:29.217891', 57, '2024-12-09 15:48:29.221236', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:48:30.057491', 58, '2024-12-09 15:48:30.061486', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:48:31.355130', 59, '2024-12-09 15:48:31.360172', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:48:31.904227', 60, '2024-12-09 15:48:31.906227', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:48:38.188994', 61, '2024-12-09 15:48:38.194262', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:49:19.262985', 62, '2024-12-09 15:49:19.262985', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:49:20.040462', 63, '2024-12-09 15:49:20.042909', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:49:20.818279', 64, '2024-12-09 15:49:20.819315', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:49:21.293321', 65, '2024-12-09 15:49:21.297401', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:49:21.879319', 66, '2024-12-09 15:49:21.883685', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:49:22.629868', 67, '2024-12-09 15:49:22.634103', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:49:23.200532', 68, '2024-12-09 15:49:23.201532', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:49:23.768720', 69, '2024-12-09 15:49:23.770792', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:49:24.275405', 70, '2024-12-09 15:49:24.278403', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:49:24.833693', 71, '2024-12-09 15:49:24.835700', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:49:29.708226', 72, '2024-12-09 15:49:29.709227', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:52:14.656835', 73, '2024-12-09 15:52:14.658350', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:52:15.633193', 74, '2024-12-09 15:52:15.636688', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:52:16.474797', 75, '2024-12-09 15:52:16.476709', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:52:17.348621', 76, '2024-12-09 15:52:17.350624', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:52:17.864657', 77, '2024-12-09 15:52:17.869934', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:52:18.302669', 78, '2024-12-09 15:52:18.305608', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:52:18.826635', 79, '2024-12-09 15:52:18.832497', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:52:19.571890', 80, '2024-12-09 15:52:19.577967', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:52:20.424841', 81, '2024-12-09 15:52:20.426823', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:52:21.154098', 82, '2024-12-09 15:52:21.159189', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:52:21.638791', 83, '2024-12-09 15:52:21.643099', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:52:22.328521', 84, '2024-12-09 15:52:22.330276', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:52:22.843669', 85, '2024-12-09 15:52:22.845823', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:52:23.456610', 86, '2024-12-09 15:52:23.458114', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:52:24.104166', 87, '2024-12-09 15:52:24.106211', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:52:24.858172', 88, '2024-12-09 15:52:24.862216', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:52:25.451613', 89, '2024-12-09 15:52:25.452615', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:52:26.110018', 90, '2024-12-09 15:52:26.114173', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:52:26.535895', 91, '2024-12-09 15:52:26.536894', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:52:27.018044', 92, '2024-12-09 15:52:27.019049', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:52:27.611927', 93, '2024-12-09 15:52:27.616569', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:52:28.223879', 94, '2024-12-09 15:52:28.225870', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:52:30.639491', 95, '2024-12-09 15:52:30.641496', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:52:31.183546', 96, '2024-12-09 15:52:31.184545', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:52:31.731968', 97, '2024-12-09 15:52:31.736458', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:52:32.433920', 98, '2024-12-09 15:52:32.439087', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:52:33.044508', 99, '2024-12-09 15:52:33.048747', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:52:34.191903', 100, '2024-12-09 15:52:34.193902', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:52:35.689737', 101, '2024-12-09 15:52:35.691737', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:52:36.417918', 102, '2024-12-09 15:52:36.419438', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:52:36.923435', 103, '2024-12-09 15:52:36.927822', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:52:37.622798', 104, '2024-12-09 15:52:37.626573', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:52:38.140456', 105, '2024-12-09 15:52:38.145079', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:52:41.831643', 106, '2024-12-09 15:52:41.831643', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:52:42.518149', 107, '2024-12-09 15:52:42.518995', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:52:43.328013', 108, '2024-12-09 15:52:43.328163', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:52:44.058167', 109, '2024-12-09 15:52:44.059176', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:52:44.903391', 110, '2024-12-09 15:52:44.908083', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (8, '123', '123', 1, 'pending', '2024-09-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:53:06.269996', '2024-12-09 15:53:06.269996', 111, '2024-12-09 15:53:06.270996', NULL, '+', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (8, '123', '123', 1, 'pending', '2024-09-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:53:06.269996', '2024-12-09 15:53:12.146375', 112, '2024-12-09 15:53:12.151583', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:53:13.401703', 113, '2024-12-09 15:53:13.402702', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:53:14.338131', 114, '2024-12-09 15:53:14.342100', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (8, '123', '123', 1, 'pending', '2024-09-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:53:06.269996', '2024-12-09 15:53:15.185988', 115, '2024-12-09 15:53:15.188023', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:53:15.851623', 116, '2024-12-09 15:53:15.852622', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:53:16.875611', 117, '2024-12-09 15:53:16.876612', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (8, '123', '123', 1, 'pending', '2024-09-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:53:06.269996', '2024-12-09 15:53:17.626642', 118, '2024-12-09 15:53:17.630085', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:53:18.255236', 119, '2024-12-09 15:53:18.258619', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:53:18.896957', 120, '2024-12-09 15:53:18.901761', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (8, '123', '123', 1, 'pending', '2024-09-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:53:06.269996', '2024-12-09 15:53:19.489853', 121, '2024-12-09 15:53:19.490834', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:53:20.226479', 122, '2024-12-09 15:53:20.229770', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:53:20.769186', 123, '2024-12-09 15:53:20.771580', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:53:21.459862', 124, '2024-12-09 15:53:21.461863', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:53:21.862948', 125, '2024-12-09 15:53:21.864948', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:53:55.644718', 126, '2024-12-09 15:53:55.647743', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:54:12.552585', 127, '2024-12-09 15:54:12.553584', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (8, '123', '123', 1, 'pending', '2024-09-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:53:06.269996', '2024-12-09 15:54:13.837928', 128, '2024-12-09 15:54:13.850114', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:54:15.334459', 129, '2024-12-09 15:54:15.336458', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:54:16.052261', 130, '2024-12-09 15:54:16.053830', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:54:17.014310', 131, '2024-12-09 15:54:17.018041', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:54:17.760030', 132, '2024-12-09 15:54:17.762035', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (8, '123', '123', 1, 'pending', '2024-09-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:53:06.269996', '2024-12-09 15:54:18.904888', 133, '2024-12-09 15:54:18.905886', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:54:39.686530', 134, '2024-12-09 15:54:39.692150', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (8, '123', '123', 1, 'pending', '2024-09-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:53:06.269996', '2024-12-09 15:54:40.403314', 135, '2024-12-09 15:54:40.405666', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:54:42.890456', 136, '2024-12-09 15:54:42.891320', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:54:43.457049', 137, '2024-12-09 15:54:43.458049', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:54:43.922457', 138, '2024-12-09 15:54:43.925120', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (8, '123', '123', 1, 'pending', '2024-09-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:53:06.269996', '2024-12-09 15:54:44.333304', 139, '2024-12-09 15:54:44.344744', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (8, '123', '123', 1, 'pending', '2024-09-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:53:06.269996', '2024-12-09 15:57:15.105590', 140, '2024-12-09 15:57:15.111469', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:57:16.472575', 141, '2024-12-09 15:57:16.472575', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:57:17.399597', 142, '2024-12-09 15:57:17.407981', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:57:18.157085', 143, '2024-12-09 15:57:18.159877', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:57:18.733285', 144, '2024-12-09 15:57:18.737683', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (8, '123', '123', 1, 'pending', '2024-09-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:53:06.269996', '2024-12-09 15:57:19.607624', 145, '2024-12-09 15:57:19.607624', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:57:20.232287', 146, '2024-12-09 15:57:20.236405', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:57:21.047608', 147, '2024-12-09 15:57:21.056380', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (8, '123', '123', 1, 'pending', '2024-09-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:53:06.269996', '2024-12-09 15:57:21.700659', 148, '2024-12-09 15:57:21.705308', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 15:57:22.190876', 149, '2024-12-09 15:57:22.194749', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:57:22.854500', 150, '2024-12-09 15:57:22.858036', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (8, '123', '123', 1, 'pending', '2024-09-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:53:06.269996', '2024-12-09 15:57:23.530095', 151, '2024-12-09 15:57:23.531598', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:57:40.052147', 152, '2024-12-09 15:57:40.057630', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (8, '123', '123', 1, 'pending', '2024-09-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:53:06.269996', '2024-12-09 15:57:43.901000', 153, '2024-12-09 15:57:43.905920', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (8, '123', '123', 1, 'pending', '2024-09-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:53:06.269996', '2024-12-09 15:57:46.814670', 154, '2024-12-09 15:57:46.816295', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (8, '123', '123', 1, 'pending', '2024-09-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:53:06.269996', '2024-12-09 15:58:01.383072', 155, '2024-12-09 15:58:01.387777', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 15:58:02.729934', 156, '2024-12-09 15:58:02.734787', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 16:00:04.190515', 157, '2024-12-09 16:00:04.191515', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (8, '123', '123', 1, 'pending', '2024-09-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:53:06.269996', '2024-12-09 16:01:12.377824', 158, '2024-12-09 16:01:12.378887', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'completed', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 16:05:23.458138', 159, '2024-12-09 16:05:23.460647', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (8, '123', '123', 1, 'completed', '2024-09-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:53:06.269996', '2024-12-09 16:05:25.242794', 160, '2024-12-09 16:05:25.244795', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'completed', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 16:05:46.104380', 161, '2024-12-09 16:05:46.108909', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (8, '123', '123', 1, 'completed', '2024-09-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:53:06.269996', '2024-12-09 16:05:46.823261', 162, '2024-12-09 16:05:46.827681', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 16:09:16.324756', 163, '2024-12-09 16:09:16.328327', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (6, '111', '111', 2, 'completed', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 16:19:13.932055', 164, '2024-12-09 16:19:13.934033', NULL, '~', 17, 5, 5);
INSERT INTO `tasks_historicaltask` VALUES (9, '123', '1231', 2, 'pending', '2024-12-09 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-10 02:54:29.157154', '2024-12-10 02:54:29.157154', 165, '2024-12-10 02:54:29.161032', NULL, '+', 2, 1, 1);
INSERT INTO `tasks_historicaltask` VALUES (10, '111', '111', 1, 'pending', '2024-12-09 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-10 03:18:00.778579', '2024-12-10 03:18:00.778579', 166, '2024-12-10 03:18:00.779576', NULL, '+', 2, 1, 1);
INSERT INTO `tasks_historicaltask` VALUES (11, '11', '11', 3, 'pending', '2024-10-09 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-10 03:21:03.632105', '2024-12-10 03:21:03.632105', 167, '2024-12-10 03:21:03.636172', NULL, '+', 6, 1, 1);
INSERT INTO `tasks_historicaltask` VALUES (12, '1212', '1212', 2, 'pending', '2024-12-09 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-10 03:35:13.115299', '2024-12-10 03:35:13.115299', 168, '2024-12-10 03:35:13.119523', NULL, '+', 2, 1, 1);
INSERT INTO `tasks_historicaltask` VALUES (13, '1212', '1212', 2, 'pending', '2024-12-09 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-10 03:35:18.837592', '2024-12-10 03:35:18.837592', 169, '2024-12-10 03:35:18.841794', NULL, '+', 2, 1, 1);
INSERT INTO `tasks_historicaltask` VALUES (14, '1212', '1212', 2, 'pending', '2024-12-09 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-10 03:35:40.153541', '2024-12-10 03:35:40.153541', 170, '2024-12-10 03:35:40.154534', NULL, '+', 2, 1, 1);
INSERT INTO `tasks_historicaltask` VALUES (15, '11', '11', 3, 'pending', '2024-12-09 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-10 03:44:22.020531', '2024-12-10 03:44:22.020531', 171, '2024-12-10 03:44:22.033151', NULL, '+', 11, 1, 1);
INSERT INTO `tasks_historicaltask` VALUES (11, '11', '11', 3, 'completed', '2024-10-09 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-10 03:21:03.632105', '2024-12-10 06:38:01.787128', 172, '2024-12-10 06:38:01.790695', NULL, '~', 6, 1, 1);
INSERT INTO `tasks_historicaltask` VALUES (15, '11', '11', 3, 'completed', '2024-12-09 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-10 03:44:22.020531', '2024-12-10 06:38:05.000363', 173, '2024-12-10 06:38:05.001878', NULL, '~', 11, 1, 1);
INSERT INTO `tasks_historicaltask` VALUES (14, '1212', '1212', 2, 'completed', '2024-12-09 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-10 03:35:40.153541', '2024-12-10 06:38:06.232179', 174, '2024-12-10 06:38:06.236883', NULL, '~', 2, 1, 1);
INSERT INTO `tasks_historicaltask` VALUES (13, '1212', '1212', 2, 'completed', '2024-12-09 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-10 03:35:18.837592', '2024-12-10 06:38:06.696549', 175, '2024-12-10 06:38:06.698814', NULL, '~', 2, 1, 1);
INSERT INTO `tasks_historicaltask` VALUES (12, '1212', '1212', 2, 'completed', '2024-12-09 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-10 03:35:13.115299', '2024-12-10 06:38:07.191956', 176, '2024-12-10 06:38:07.193767', NULL, '~', 2, 1, 1);
INSERT INTO `tasks_historicaltask` VALUES (9, '123', '1231', 2, 'completed', '2024-12-09 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-10 02:54:29.157154', '2024-12-10 06:38:07.640708', 177, '2024-12-10 06:38:07.643826', NULL, '~', 2, 1, 1);
INSERT INTO `tasks_historicaltask` VALUES (5, '11', '11', 2, 'completed', '2024-12-20 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 14:41:50.760126', '2024-12-10 06:38:08.057980', 178, '2024-12-10 06:38:08.059316', NULL, '~', 2, 1, 1);
INSERT INTO `tasks_historicaltask` VALUES (16, '列表列表', '列表列表', 1, 'pending', '2024-11-09 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-10 12:29:00.326191', '2024-12-10 12:29:00.326191', 179, '2024-12-10 12:29:00.327189', NULL, '+', 2, 1, 1);
INSERT INTO `tasks_historicaltask` VALUES (17, 'fff', 'dff', 3, 'pending', '2024-06-09 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-10 12:29:30.723174', '2024-12-10 12:29:30.723174', 180, '2024-12-10 12:29:30.725173', NULL, '+', 10, 1, 1);
INSERT INTO `tasks_historicaltask` VALUES (18, 'fwef', 'fsdfasdf', 3, 'pending', '2024-12-09 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-10 12:46:58.801049', '2024-12-10 12:46:58.801049', 181, '2024-12-10 12:46:58.805882', NULL, '+', 8, 1, 1);

-- ----------------------------
-- Table structure for tasks_historicaltaskcomment
-- ----------------------------
DROP TABLE IF EXISTS `tasks_historicaltaskcomment`;
CREATE TABLE `tasks_historicaltaskcomment`  (
  `id` bigint NOT NULL,
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `history_id` int NOT NULL AUTO_INCREMENT,
  `history_date` datetime(6) NOT NULL,
  `history_change_reason` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `history_type` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `history_user_id` bigint NULL DEFAULT NULL,
  `user_id` bigint NULL DEFAULT NULL,
  `task_id` bigint NULL DEFAULT NULL,
  PRIMARY KEY (`history_id`) USING BTREE,
  INDEX `tasks_historicaltask_history_user_id_ef3f7c3f_fk_accounts_`(`history_user_id` ASC) USING BTREE,
  INDEX `tasks_historicaltaskcomment_id_5173cd6a`(`id` ASC) USING BTREE,
  INDEX `tasks_historicaltaskcomment_history_date_9ed2d99d`(`history_date` ASC) USING BTREE,
  INDEX `tasks_historicaltaskcomment_user_id_0c37f0e0`(`user_id` ASC) USING BTREE,
  INDEX `tasks_historicaltaskcomment_task_id_6ef3a02a`(`task_id` ASC) USING BTREE,
  CONSTRAINT `tasks_historicaltask_history_user_id_ef3f7c3f_fk_accounts_` FOREIGN KEY (`history_user_id`) REFERENCES `accounts_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tasks_historicaltaskcomment
-- ----------------------------
INSERT INTO `tasks_historicaltaskcomment` VALUES (1, '这部分需要修改一下格式', '2024-12-09 12:55:48.644291', '2024-12-09 12:55:48.644291', 1, '2024-12-09 12:55:48.648600', NULL, '+', 4, 4, 3);
INSERT INTO `tasks_historicaltaskcomment` VALUES (2, '这部分需要修改一下格式', '2024-12-09 12:55:53.358027', '2024-12-09 12:55:53.358027', 2, '2024-12-09 12:55:53.363912', NULL, '+', 4, 4, 3);
INSERT INTO `tasks_historicaltaskcomment` VALUES (3, '这部分需要修改一下格式', '2024-12-09 12:55:54.140099', '2024-12-09 12:55:54.140099', 3, '2024-12-09 12:55:54.142047', NULL, '+', 4, 4, 3);
INSERT INTO `tasks_historicaltaskcomment` VALUES (4, '这部分需要修改一下格式', '2024-12-09 12:55:54.698455', '2024-12-09 12:55:54.698455', 4, '2024-12-09 12:55:54.703884', NULL, '+', 4, 4, 3);
INSERT INTO `tasks_historicaltaskcomment` VALUES (5, '这部分需要修改一下格式', '2024-12-09 12:55:55.217938', '2024-12-09 12:55:55.217938', 5, '2024-12-09 12:55:55.219556', NULL, '+', 4, 4, 3);
INSERT INTO `tasks_historicaltaskcomment` VALUES (6, '这部分需要修改一下格式', '2024-12-09 12:55:55.684984', '2024-12-09 12:55:55.684984', 6, '2024-12-09 12:55:55.688842', NULL, '+', 4, 4, 3);
INSERT INTO `tasks_historicaltaskcomment` VALUES (7, '这部分需要修改一下格式', '2024-12-09 12:55:55.924508', '2024-12-09 12:55:55.924508', 7, '2024-12-09 12:55:55.928233', NULL, '+', 4, 4, 3);
INSERT INTO `tasks_historicaltaskcomment` VALUES (8, '这部分需要修改一下格式', '2024-12-09 12:55:56.136976', '2024-12-09 12:55:56.136976', 8, '2024-12-09 12:55:56.137983', NULL, '+', 4, 4, 3);
INSERT INTO `tasks_historicaltaskcomment` VALUES (9, '这部分需要修改一下格式', '2024-12-09 12:55:56.359176', '2024-12-09 12:55:56.359176', 9, '2024-12-09 12:55:56.361149', NULL, '+', 4, 4, 3);
INSERT INTO `tasks_historicaltaskcomment` VALUES (10, '这部分需要修改一下格式', '2024-12-09 12:55:56.584931', '2024-12-09 12:55:56.584931', 10, '2024-12-09 12:55:56.592289', NULL, '+', 4, 4, 3);
INSERT INTO `tasks_historicaltaskcomment` VALUES (11, '这部分需要修改一下格式', '2024-12-09 12:55:56.830405', '2024-12-09 12:55:56.830405', 11, '2024-12-09 12:55:56.834377', NULL, '+', 4, 4, 3);
INSERT INTO `tasks_historicaltaskcomment` VALUES (12, '这部分需要修改一下格式', '2024-12-09 12:55:57.025653', '2024-12-09 12:55:57.025653', 12, '2024-12-09 12:55:57.027089', NULL, '+', 4, 4, 3);
INSERT INTO `tasks_historicaltaskcomment` VALUES (13, '这部分需要修改一下格式', '2024-12-09 12:55:57.217999', '2024-12-09 12:55:57.217999', 13, '2024-12-09 12:55:57.217999', NULL, '+', 4, 4, 3);
INSERT INTO `tasks_historicaltaskcomment` VALUES (14, '这部分需要修改一下格式', '2024-12-09 12:55:57.437037', '2024-12-09 12:55:57.437037', 14, '2024-12-09 12:55:57.439037', NULL, '+', 4, 4, 3);
INSERT INTO `tasks_historicaltaskcomment` VALUES (15, '这部分需要修改一下格式', '2024-12-09 12:55:57.645090', '2024-12-09 12:55:57.645090', 15, '2024-12-09 12:55:57.645090', NULL, '+', 4, 4, 3);
INSERT INTO `tasks_historicaltaskcomment` VALUES (16, '这部分需要修改一下格式', '2024-12-09 12:55:57.881496', '2024-12-09 12:55:57.881496', 16, '2024-12-09 12:55:57.885462', NULL, '+', 4, 4, 3);
INSERT INTO `tasks_historicaltaskcomment` VALUES (17, '这部分需要修改一下格式', '2024-12-09 12:55:58.077421', '2024-12-09 12:55:58.077421', 17, '2024-12-09 12:55:58.078427', NULL, '+', 4, 4, 3);

-- ----------------------------
-- Table structure for tasks_historicaltasksync
-- ----------------------------
DROP TABLE IF EXISTS `tasks_historicaltasksync`;
CREATE TABLE `tasks_historicaltasksync`  (
  `id` bigint NOT NULL,
  `last_sync_time` datetime(6) NOT NULL,
  `sync_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `sync_error` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `history_id` int NOT NULL AUTO_INCREMENT,
  `history_date` datetime(6) NOT NULL,
  `history_change_reason` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `history_type` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `device_id` bigint NULL DEFAULT NULL,
  `history_user_id` bigint NULL DEFAULT NULL,
  `task_id` bigint NULL DEFAULT NULL,
  PRIMARY KEY (`history_id`) USING BTREE,
  INDEX `tasks_historicaltask_history_user_id_a6f90875_fk_accounts_`(`history_user_id` ASC) USING BTREE,
  INDEX `tasks_historicaltasksync_id_8567ab6e`(`id` ASC) USING BTREE,
  INDEX `tasks_historicaltasksync_history_date_c5f637cd`(`history_date` ASC) USING BTREE,
  INDEX `tasks_historicaltasksync_device_id_422f4a53`(`device_id` ASC) USING BTREE,
  INDEX `tasks_historicaltasksync_task_id_b37002f7`(`task_id` ASC) USING BTREE,
  CONSTRAINT `tasks_historicaltask_history_user_id_a6f90875_fk_accounts_` FOREIGN KEY (`history_user_id`) REFERENCES `accounts_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tasks_historicaltasksync
-- ----------------------------

-- ----------------------------
-- Table structure for tasks_tag
-- ----------------------------
DROP TABLE IF EXISTS `tasks_tag`;
CREATE TABLE `tasks_tag`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `color` varchar(7) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `tasks_tag_user_id_name_3f9fa893_uniq`(`user_id` ASC, `name` ASC) USING BTREE,
  CONSTRAINT `tasks_tag_user_id_5724594a_fk_accounts_user_id` FOREIGN KEY (`user_id`) REFERENCES `accounts_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tasks_tag
-- ----------------------------
INSERT INTO `tasks_tag` VALUES (1, '个人', '#0033FF', '2024-12-09 12:46:10.889522', '2024-12-09 12:46:10.889522', 4);
INSERT INTO `tasks_tag` VALUES (3, '个人1', '#0033FF', '2024-12-09 12:48:33.417726', '2024-12-09 12:48:33.417726', 4);

-- ----------------------------
-- Table structure for tasks_task
-- ----------------------------
DROP TABLE IF EXISTS `tasks_task`;
CREATE TABLE `tasks_task`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `priority` int NOT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `due_date` datetime(6) NULL DEFAULT NULL,
  `reminder_time` datetime(6) NULL DEFAULT NULL,
  `repeat_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `repeat_config` json NULL,
  `completed_at` datetime(6) NULL DEFAULT NULL,
  `is_important` tinyint(1) NOT NULL,
  `order` int NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `category_id` bigint NULL DEFAULT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `tasks_task_category_id_ec02979a_fk_tasks_category_id`(`category_id` ASC) USING BTREE,
  INDEX `tasks_task_user_id_f0e531b0_fk_accounts_user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `tasks_task_category_id_ec02979a_fk_tasks_category_id` FOREIGN KEY (`category_id`) REFERENCES `tasks_category` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `tasks_task_user_id_f0e531b0_fk_accounts_user_id` FOREIGN KEY (`user_id`) REFERENCES `accounts_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tasks_task
-- ----------------------------
INSERT INTO `tasks_task` VALUES (1, '准备会议材料', '准备下周一的项目进度会议材料', 1, 'pending', '2024-12-15 14:00:00.000000', NULL, 'none', NULL, NULL, 1, 0, '2024-12-09 12:54:10.202760', '2024-12-09 12:54:10.202760', 1, 4);
INSERT INTO `tasks_task` VALUES (2, '准备会议材料', '准备下周一的项目进度会议材料', 1, 'pending', '2024-12-15 14:00:00.000000', NULL, 'none', NULL, NULL, 1, 0, '2024-12-09 12:54:26.747825', '2024-12-09 12:54:26.747825', 1, 4);
INSERT INTO `tasks_task` VALUES (3, '准备会议材料', '准备下周一的项目进度会议材料', 1, 'pending', '2024-12-15 14:00:00.000000', NULL, 'none', NULL, NULL, 1, 0, '2024-12-09 12:54:36.879119', '2024-12-09 12:54:36.879119', 1, 4);
INSERT INTO `tasks_task` VALUES (4, '准备会议材料', '准备下周一的项目进度会议材料', 1, 'pending', '2024-12-15 14:00:00.000000', NULL, 'none', NULL, NULL, 1, 0, '2024-12-09 12:54:40.977028', '2024-12-09 12:54:40.977028', 1, 4);
INSERT INTO `tasks_task` VALUES (5, '11', '11', 2, 'completed', '2024-12-20 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 14:41:50.760126', '2024-12-10 06:38:08.057980', 2, 1);
INSERT INTO `tasks_task` VALUES (6, '111', '111', 2, 'completed', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.021758', '2024-12-09 16:19:13.932055', 17, 5);
INSERT INTO `tasks_task` VALUES (7, '111', '111', 2, 'pending', '2019-12-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:24:35.283262', '2024-12-09 16:09:16.324756', 17, 5);
INSERT INTO `tasks_task` VALUES (8, '123', '123', 1, 'completed', '2024-09-08 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-09 15:53:06.269996', '2024-12-09 16:05:46.823261', 17, 5);
INSERT INTO `tasks_task` VALUES (9, '123', '1231', 2, 'completed', '2024-12-09 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-10 02:54:29.157154', '2024-12-10 06:38:07.640708', 2, 1);
INSERT INTO `tasks_task` VALUES (10, '111', '111', 1, 'pending', '2024-12-09 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-10 03:18:00.778579', '2024-12-10 03:18:00.778579', 2, 1);
INSERT INTO `tasks_task` VALUES (11, '11', '11', 3, 'completed', '2024-10-09 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-10 03:21:03.632105', '2024-12-10 06:38:01.787128', 6, 1);
INSERT INTO `tasks_task` VALUES (12, '1212', '1212', 2, 'completed', '2024-12-09 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-10 03:35:13.115299', '2024-12-10 06:38:07.191956', 2, 1);
INSERT INTO `tasks_task` VALUES (13, '1212', '1212', 2, 'completed', '2024-12-09 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-10 03:35:18.837592', '2024-12-10 06:38:06.696549', 2, 1);
INSERT INTO `tasks_task` VALUES (14, '1212', '1212', 2, 'completed', '2024-12-09 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-10 03:35:40.153541', '2024-12-10 06:38:06.232179', 2, 1);
INSERT INTO `tasks_task` VALUES (15, '11', '11', 3, 'completed', '2024-12-09 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-10 03:44:22.020531', '2024-12-10 06:38:05.000363', 11, 1);
INSERT INTO `tasks_task` VALUES (16, '列表列表', '列表列表', 1, 'pending', '2024-11-09 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-10 12:29:00.326191', '2024-12-10 12:29:00.326191', 2, 1);
INSERT INTO `tasks_task` VALUES (17, 'fff', 'dff', 3, 'pending', '2024-06-09 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-10 12:29:30.723174', '2024-12-10 12:29:30.723174', 10, 1);
INSERT INTO `tasks_task` VALUES (18, 'fwef', 'fsdfasdf', 3, 'pending', '2024-12-09 16:00:00.000000', NULL, 'none', NULL, NULL, 0, 0, '2024-12-10 12:46:58.801049', '2024-12-10 12:46:58.801049', 8, 1);

-- ----------------------------
-- Table structure for tasks_task_tags
-- ----------------------------
DROP TABLE IF EXISTS `tasks_task_tags`;
CREATE TABLE `tasks_task_tags`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `task_id` bigint NOT NULL,
  `tag_id` bigint NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `tasks_task_tags_task_id_tag_id_f35a003e_uniq`(`task_id` ASC, `tag_id` ASC) USING BTREE,
  INDEX `tasks_task_tags_tag_id_dc501020_fk_tasks_tag_id`(`tag_id` ASC) USING BTREE,
  CONSTRAINT `tasks_task_tags_tag_id_dc501020_fk_tasks_tag_id` FOREIGN KEY (`tag_id`) REFERENCES `tasks_tag` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `tasks_task_tags_task_id_7f3deefe_fk_tasks_task_id` FOREIGN KEY (`task_id`) REFERENCES `tasks_task` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tasks_task_tags
-- ----------------------------
INSERT INTO `tasks_task_tags` VALUES (1, 1, 1);
INSERT INTO `tasks_task_tags` VALUES (2, 2, 1);
INSERT INTO `tasks_task_tags` VALUES (3, 3, 1);
INSERT INTO `tasks_task_tags` VALUES (4, 4, 1);

-- ----------------------------
-- Table structure for tasks_taskcomment
-- ----------------------------
DROP TABLE IF EXISTS `tasks_taskcomment`;
CREATE TABLE `tasks_taskcomment`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `task_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `tasks_taskcomment_task_id_36403ad8_fk_tasks_task_id`(`task_id` ASC) USING BTREE,
  INDEX `tasks_taskcomment_user_id_8cc0fe19_fk_accounts_user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `tasks_taskcomment_task_id_36403ad8_fk_tasks_task_id` FOREIGN KEY (`task_id`) REFERENCES `tasks_task` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `tasks_taskcomment_user_id_8cc0fe19_fk_accounts_user_id` FOREIGN KEY (`user_id`) REFERENCES `accounts_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tasks_taskcomment
-- ----------------------------
INSERT INTO `tasks_taskcomment` VALUES (1, '这部分需要修改一下格式', '2024-12-09 12:55:48.644291', '2024-12-09 12:55:48.644291', 3, 4);
INSERT INTO `tasks_taskcomment` VALUES (2, '这部分需要修改一下格式', '2024-12-09 12:55:53.358027', '2024-12-09 12:55:53.358027', 3, 4);
INSERT INTO `tasks_taskcomment` VALUES (3, '这部分需要修改一下格式', '2024-12-09 12:55:54.140099', '2024-12-09 12:55:54.140099', 3, 4);
INSERT INTO `tasks_taskcomment` VALUES (4, '这部分需要修改一下格式', '2024-12-09 12:55:54.698455', '2024-12-09 12:55:54.698455', 3, 4);
INSERT INTO `tasks_taskcomment` VALUES (5, '这部分需要修改一下格式', '2024-12-09 12:55:55.217938', '2024-12-09 12:55:55.217938', 3, 4);
INSERT INTO `tasks_taskcomment` VALUES (6, '这部分需要修改一下格式', '2024-12-09 12:55:55.684984', '2024-12-09 12:55:55.684984', 3, 4);
INSERT INTO `tasks_taskcomment` VALUES (7, '这部分需要修改一下格式', '2024-12-09 12:55:55.924508', '2024-12-09 12:55:55.924508', 3, 4);
INSERT INTO `tasks_taskcomment` VALUES (8, '这部分需要修改一下格式', '2024-12-09 12:55:56.136976', '2024-12-09 12:55:56.136976', 3, 4);
INSERT INTO `tasks_taskcomment` VALUES (9, '这部分需要修改一下格式', '2024-12-09 12:55:56.359176', '2024-12-09 12:55:56.359176', 3, 4);
INSERT INTO `tasks_taskcomment` VALUES (10, '这部分需要修改一下格式', '2024-12-09 12:55:56.584931', '2024-12-09 12:55:56.584931', 3, 4);
INSERT INTO `tasks_taskcomment` VALUES (11, '这部分需要修改一下格式', '2024-12-09 12:55:56.830405', '2024-12-09 12:55:56.830405', 3, 4);
INSERT INTO `tasks_taskcomment` VALUES (12, '这部分需要修改一下格式', '2024-12-09 12:55:57.025653', '2024-12-09 12:55:57.025653', 3, 4);
INSERT INTO `tasks_taskcomment` VALUES (13, '这部分需要修改一下格式', '2024-12-09 12:55:57.217999', '2024-12-09 12:55:57.217999', 3, 4);
INSERT INTO `tasks_taskcomment` VALUES (14, '这部分需要修改一下格式', '2024-12-09 12:55:57.437037', '2024-12-09 12:55:57.437037', 3, 4);
INSERT INTO `tasks_taskcomment` VALUES (15, '这部分需要修改一下格式', '2024-12-09 12:55:57.645090', '2024-12-09 12:55:57.645090', 3, 4);
INSERT INTO `tasks_taskcomment` VALUES (16, '这部分需要修改一下格式', '2024-12-09 12:55:57.881496', '2024-12-09 12:55:57.881496', 3, 4);
INSERT INTO `tasks_taskcomment` VALUES (17, '这部分需要修改一下格式', '2024-12-09 12:55:58.077421', '2024-12-09 12:55:58.077421', 3, 4);

-- ----------------------------
-- Table structure for tasks_tasksync
-- ----------------------------
DROP TABLE IF EXISTS `tasks_tasksync`;
CREATE TABLE `tasks_tasksync`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `last_sync_time` datetime(6) NOT NULL,
  `sync_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `sync_error` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `device_id` bigint NOT NULL,
  `task_id` bigint NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `tasks_tasksync_task_id_device_id_9ffeb88b_uniq`(`task_id` ASC, `device_id` ASC) USING BTREE,
  INDEX `tasks_tasksync_device_id_10af4fa1_fk_accounts_userdevice_id`(`device_id` ASC) USING BTREE,
  CONSTRAINT `tasks_tasksync_device_id_10af4fa1_fk_accounts_userdevice_id` FOREIGN KEY (`device_id`) REFERENCES `accounts_userdevice` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `tasks_tasksync_task_id_0b694d94_fk_tasks_task_id` FOREIGN KEY (`task_id`) REFERENCES `tasks_task` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tasks_tasksync
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
