-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 09, 2025 at 01:31 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `nstitute_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `advertisements`
--

CREATE TABLE `advertisements` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` varchar(255) NOT NULL,
  `image` varchar(255) NOT NULL,
  `publish_date` date NOT NULL DEFAULT '2025-03-08',
  `end_date` date NOT NULL,
  `state` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `advertisements`
--

INSERT INTO `advertisements` (`id`, `title`, `content`, `image`, `publish_date`, `end_date`, `state`, `created_at`, `updated_at`) VALUES
(1, 'new اعلان جديدددد', 'infooooo about   adv', 'logo1.png', '2025-03-09', '2025-03-22', 1, '2025-03-10 13:30:36', '2025-03-10 13:52:59'),
(2, 'اعلان ججديد', 'بببببببببببببببببببببببببببببببببببببببببببببببببب', 'avatar.png', '2025-03-10', '2025-03-11', 1, '2025-03-10 13:44:12', '2025-03-10 13:45:45');

-- --------------------------------------------------------

--
-- Table structure for table `attendances`
--

CREATE TABLE `attendances` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `student_id` bigint(20) UNSIGNED NOT NULL,
  `session_id` bigint(20) UNSIGNED NOT NULL,
  `employee_id` bigint(20) UNSIGNED NOT NULL,
  `attendance_date` datetime NOT NULL DEFAULT '2025-03-08 14:52:32',
  `status` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `attendances`
--

INSERT INTO `attendances` (`id`, `student_id`, `session_id`, `employee_id`, `attendance_date`, `status`, `created_at`, `updated_at`) VALUES
(139, 3, 1, 1, '2025-03-20 00:00:00', 0, '2025-03-20 06:42:00', '2025-03-20 06:42:00'),
(140, 4, 1, 1, '2025-03-20 00:00:00', 1, '2025-03-20 06:42:00', '2025-03-20 06:42:00'),
(141, 4, 1, 1, '2025-03-20 00:00:00', 0, '2025-03-20 06:42:00', '2025-03-20 06:42:00'),
(142, 4, 1, 1, '2025-03-20 00:00:00', 1, '2025-03-20 06:42:00', '2025-03-20 06:42:00'),
(143, 4, 1, 1, '2025-03-20 00:00:00', 1, '2025-03-20 06:42:00', '2025-03-20 06:42:00'),
(145, 2, 3, 1, '2025-03-20 00:00:00', 1, '2025-03-20 06:46:55', '2025-03-20 06:54:29'),
(146, 2, 3, 1, '2025-03-20 00:00:00', 1, '2025-03-20 06:46:55', '2025-03-20 06:46:55'),
(147, 10, 4, 1, '2025-03-20 00:00:00', 1, '2025-03-20 06:48:11', '2025-03-20 06:48:11'),
(148, 3, 5, 5, '2025-03-08 14:52:32', 1, NULL, NULL),
(149, 4, 1, 1, '2025-03-08 14:52:32', 1, NULL, NULL),
(150, 4, 2, 2, '2025-03-08 14:52:32', 1, NULL, NULL),
(151, 4, 2, 2, '2025-03-08 14:52:32', 1, NULL, NULL),
(152, 4, 2, 2, '2025-03-08 14:52:32', 1, NULL, NULL),
(153, 4, 2, 2, '2025-03-08 14:52:32', 0, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `courses`
--

CREATE TABLE `courses` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `department_id` bigint(20) UNSIGNED DEFAULT NULL,
  `course_name` varchar(255) NOT NULL,
  `duration` int(11) DEFAULT NULL,
  `description` varchar(200) NOT NULL,
  `state` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `courses`
--

INSERT INTO `courses` (`id`, `department_id`, `course_name`, `duration`, `description`, `state`, `created_at`, `updated_at`) VALUES
(1, 1, 'بايثون', 40, 'برمجية', 0, '2025-03-09 19:48:38', '2025-03-09 19:48:38'),
(2, 2, 'access1', 50, 'دورة تعلم انجليزي', 0, '2025-03-09 19:49:05', '2025-03-09 19:49:38'),
(3, 1, 'بايثون4', 55, 'gftrxsrz', 0, '2025-03-10 17:09:01', '2025-03-10 17:09:01'),
(4, 2, 'english', 40, 'تعلم انجليزي', 0, '2025-03-22 06:51:40', '2025-03-22 06:51:40');

-- --------------------------------------------------------

--
-- Table structure for table `course_evaluations`
--

CREATE TABLE `course_evaluations` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `student_id` bigint(20) UNSIGNED NOT NULL,
  `course_session_id` bigint(20) UNSIGNED NOT NULL,
  `rating` int(11) NOT NULL,
  `feedback` text DEFAULT NULL,
  `date` date NOT NULL DEFAULT '2025-03-08',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `course_evaluations`
--

INSERT INTO `course_evaluations` (`id`, `student_id`, `course_session_id`, `rating`, `feedback`, `date`, `created_at`, `updated_at`) VALUES
(9, 4, 1, 1, '', '2025-04-07', NULL, NULL),
(10, 4, 2, 3, 'sa', '2025-04-07', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `course_prices`
--

CREATE TABLE `course_prices` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `session_id` bigint(20) UNSIGNED DEFAULT NULL,
  `course_id` bigint(20) UNSIGNED NOT NULL,
  `price` int(11) NOT NULL,
  `date` date NOT NULL,
  `price_approval` date NOT NULL,
  `state` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `course_prices`
--

INSERT INTO `course_prices` (`id`, `session_id`, `course_id`, `price`, `date`, `price_approval`, `state`, `created_at`, `updated_at`) VALUES
(1, NULL, 1, 10000, '2025-03-10', '2025-03-20', 1, '2025-03-09 19:52:54', '2025-03-09 19:52:54'),
(2, 2, 4, 3000, '2025-03-01', '2025-04-10', 1, NULL, NULL),
(4, 1, 1, 4000, '0000-00-00', '0000-00-00', 0, NULL, NULL),
(5, 5, 2, 200, '0000-00-00', '0000-00-00', 1, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `course_sessions`
--

CREATE TABLE `course_sessions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `course_id` bigint(20) UNSIGNED NOT NULL,
  `employee_id` bigint(20) UNSIGNED NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `daily_hours` int(11) NOT NULL DEFAULT 2,
  `state` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `course_sessions`
--

INSERT INTO `course_sessions` (`id`, `course_id`, `employee_id`, `start_date`, `end_date`, `start_time`, `end_time`, `daily_hours`, `state`, `created_at`, `updated_at`) VALUES
(1, 1, 1, '2025-03-04', '2025-03-16', '10:00:00', '02:00:00', 4, 0, '2025-03-10 07:28:19', '2025-03-10 15:41:23'),
(2, 2, 2, '2025-03-05', '2025-03-20', '22:40:00', '01:40:00', 4, 1, '2025-03-10 15:40:16', '2025-03-10 15:40:16'),
(3, 1, 2, '2025-03-10', '2025-04-02', '08:00:00', '10:00:00', 2, 1, '2025-03-10 15:43:19', '2025-03-10 15:43:44'),
(4, 2, 1, '2025-03-19', '2025-04-17', '10:00:00', '12:00:00', 2, 1, '2025-03-20 04:47:21', '2025-03-20 04:47:21'),
(5, 4, 5, '2025-03-22', '2025-04-14', '10:00:00', '12:00:00', 2, 1, '2025-03-22 06:52:22', '2025-03-22 06:52:22');

-- --------------------------------------------------------

--
-- Table structure for table `course_session_students`
--

CREATE TABLE `course_session_students` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `student_id` bigint(20) UNSIGNED NOT NULL,
  `course_session_id` bigint(20) UNSIGNED NOT NULL,
  `register_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` enum('pending','in_progress','completed','failed','dropped') NOT NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `course_session_students`
--

INSERT INTO `course_session_students` (`id`, `student_id`, `course_session_id`, `register_at`, `status`, `created_at`, `updated_at`) VALUES
(1, 3, 1, '2025-03-10 10:48:13', 'completed', '2025-03-10 07:48:13', '2025-03-10 07:48:13'),
(2, 4, 1, '2025-03-10 11:17:11', 'completed', '2025-03-10 08:17:11', '2025-03-10 08:17:11'),
(3, 5, 1, '2025-03-10 11:22:02', 'pending', '2025-03-10 08:22:02', '2025-03-10 08:22:02'),
(4, 6, 1, '2025-03-10 11:35:26', 'pending', '2025-03-10 08:35:26', '2025-03-10 08:35:26'),
(5, 9, 1, '2025-03-10 11:53:32', 'completed', '2025-03-10 08:53:32', '2025-03-10 08:53:32'),
(6, 4, 2, '2025-03-13 11:26:09', 'completed', NULL, NULL),
(7, 10, 4, '2025-03-20 07:47:59', 'pending', NULL, NULL),
(8, 5, 3, '2025-03-20 08:59:47', 'pending', NULL, NULL),
(9, 7, 3, '2025-03-20 08:59:47', 'pending', NULL, NULL),
(10, 4, 5, '2025-03-22 09:53:05', 'in_progress', NULL, NULL),
(11, 11, 1, '2025-03-26 07:38:01', 'pending', '2025-03-26 04:38:01', '2025-03-26 04:38:01'),
(12, 12, 1, '2025-04-05 07:15:46', 'in_progress', NULL, NULL),
(13, 2, 5, '2025-04-05 07:16:10', 'completed', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `course_students`
--

CREATE TABLE `course_students` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `student_id` bigint(20) UNSIGNED NOT NULL,
  `course_id` bigint(20) UNSIGNED NOT NULL,
  `study_time` enum('8-10','10-12','12-2','2-4','4-6') DEFAULT NULL,
  `status` enum('waiting','cancelled') NOT NULL DEFAULT 'waiting',
  `register_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `course_students`
--

INSERT INTO `course_students` (`id`, `student_id`, `course_id`, `study_time`, `status`, `register_at`, `created_at`, `updated_at`) VALUES
(1, 8, 2, '2-4', 'waiting', '2025-03-10 08:44:41', '2025-03-10 08:44:41', '2025-03-10 08:44:41'),
(2, 10, 1, '8-10', 'waiting', '2025-03-10 15:46:18', '2025-03-10 15:46:18', '2025-03-10 15:46:18'),
(3, 12, 1, '8-10', 'cancelled', '2025-03-26 08:45:25', '2025-03-26 08:45:25', '2025-03-26 08:45:25'),
(4, 13, 1, '8-10', 'waiting', '2025-03-26 08:58:04', '2025-03-26 08:58:04', '2025-03-26 08:58:04'),
(5, 14, 1, '8-10', 'waiting', '2025-03-26 09:00:21', '2025-03-26 09:00:21', '2025-03-26 09:00:21'),
(6, 15, 1, '8-10', 'waiting', '2025-03-26 09:33:46', '2025-03-26 09:33:46', '2025-03-26 09:33:46'),
(7, 16, 1, '8-10', 'waiting', '2025-03-26 09:45:51', '2025-03-26 09:45:51', '2025-03-26 09:45:51'),
(8, 17, 1, '8-10', 'waiting', '2025-03-26 10:02:22', '2025-03-26 10:02:22', '2025-03-26 10:02:22'),
(10, 12, 2, '2-4', 'cancelled', '2025-04-05 00:56:10', NULL, NULL),
(11, 12, 4, '4-6', 'cancelled', '2025-04-05 00:56:58', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `degrees`
--

CREATE TABLE `degrees` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `student_id` bigint(20) UNSIGNED NOT NULL,
  `course_session_id` bigint(20) UNSIGNED NOT NULL,
  `practical_degree` decimal(5,2) NOT NULL,
  `final_degree` decimal(5,2) NOT NULL,
  `attendance_degree` decimal(5,2) NOT NULL,
  `total_degree` decimal(5,2) NOT NULL,
  `status` enum('pass','fail') DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `degrees`
--

INSERT INTO `degrees` (`id`, `student_id`, `course_session_id`, `practical_degree`, `final_degree`, `attendance_degree`, `total_degree`, `status`, `created_at`, `updated_at`) VALUES
(6, 3, 1, 22.00, 11.00, 2.00, 35.00, 'pass', '2025-03-20 09:49:36', '2025-03-22 04:22:08'),
(7, 4, 1, 33.00, 33.00, 0.00, 66.00, 'pass', '2025-03-20 09:49:36', '2025-03-20 17:26:38'),
(8, 5, 1, 88.00, 44.00, 2.00, 134.00, 'pass', '2025-03-20 09:49:36', '2025-03-22 04:22:08'),
(9, 6, 1, 10.00, 10.00, 20.00, 88.00, 'fail', '2025-03-20 09:49:36', '2025-03-20 17:11:13'),
(10, 9, 1, 10.00, 20.00, 10.00, 40.00, 'fail', '2025-03-20 09:49:36', '2025-03-20 17:11:13'),
(11, 5, 3, 33.00, 44.00, 5.00, 82.00, 'fail', '2025-03-20 11:10:57', '2025-03-20 17:36:12'),
(12, 7, 3, 55.00, 22.00, 0.00, 77.00, 'pass', '2025-03-20 11:10:57', '2025-03-20 17:36:12'),
(13, 4, 2, 10.00, 40.00, 10.00, 60.00, 'pass', '2025-03-20 11:20:37', '2025-03-20 17:33:20'),
(14, 10, 4, 33.00, 33.00, 0.00, 66.00, 'pass', '2025-03-20 11:57:01', '2025-03-20 17:14:45'),
(15, 12, 5, 85.00, 90.00, 25.00, 200.00, 'pass', '2025-04-05 07:16:58', '2025-04-05 07:16:58');

-- --------------------------------------------------------

--
-- Table structure for table `departments`
--

CREATE TABLE `departments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `department_name` varchar(255) NOT NULL,
  `department_info` varchar(255) NOT NULL,
  `state` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `departments`
--

INSERT INTO `departments` (`id`, `department_name`, `department_info`, `state`, `created_at`, `updated_at`) VALUES
(1, 'حاسوب', 'قسم برمجة', 1, '2025-03-09 19:47:17', '2025-03-09 21:11:43'),
(2, 'انجليزي', 'قسم انجليزي', 1, '2025-03-09 19:47:46', '2025-03-09 19:47:46'),
(3, 'ادارة اعمال', 'كلكلكل', 1, NULL, NULL),
(4, 'تقوية ثالث ثانوي', 'مممممممممممممممممممم', 1, NULL, NULL),
(5, 'محاسبه', 'نن', 0, NULL, NULL),
(6, 'جارفكس', 'خخخخخ', 1, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `employees`
--

CREATE TABLE `employees` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `name_en` varchar(300) NOT NULL,
  `name_ar` varchar(300) NOT NULL,
  `phones` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`phones`)),
  `address` varchar(255) NOT NULL,
  `gender` enum('male','female') NOT NULL,
  `birth_date` date NOT NULL,
  `birth_place` varchar(255) NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `emptype` varchar(255) NOT NULL,
  `state` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `employees`
--

INSERT INTO `employees` (`id`, `user_id`, `name_en`, `name_ar`, `phones`, `address`, `gender`, `birth_date`, `birth_place`, `image`, `email`, `emptype`, `state`, `created_at`, `updated_at`) VALUES
(1, 7, 'lawzah', 'لوزة الصعدي', '222221234', 'sanaa', 'male', '2025-03-04', 'إب', 'avatar.png', 'laawddzah@gmail.com', 'teacher', 1, '2025-03-09 20:45:57', '2025-03-09 21:39:39'),
(2, 8, 'lawzah', 'لوزة صالح', '\"555555555,6666666666\"', 'sanaa', 'female', '2025-03-05', 'الحديدة', 'login.png', 'lawzahsa@gmail.com', 'teacher', 1, '2025-03-09 21:44:21', '2025-03-09 21:44:21'),
(3, 9, 'lawzah saleh', 'لوزة الصعدي', '\"77777777,6666666\"', 'sanaa', 'female', '2025-03-03', 'إب', NULL, 'lawzah.s.alsade@gmail.com', 'admin', 1, '2025-03-09 22:05:33', '2025-03-09 22:05:33'),
(4, 10, 'lawzah saleh', 'لوزة الصعدي', '\"77777777,6666666\"', 'sanaa', 'female', '2025-03-04', 'إب', NULL, 'eygEfvil@gmail.com', 'admin', 1, '2025-03-09 22:16:34', '2025-03-09 22:16:34'),
(5, 20, 'lawzah', 'لوزة', '\"555555555,6666666666\"', 'sanrraa', 'female', '2025-02-24', 'صنعاء', '', 'lawzahteacher@gmail.com', 'teacher', 1, '2025-03-21 11:26:38', '2025-03-21 11:26:38');

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `holidays`
--

CREATE TABLE `holidays` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `date` date NOT NULL,
  `name` varchar(255) NOT NULL,
  `state` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `holidays`
--

INSERT INTO `holidays` (`id`, `date`, `name`, `state`, `created_at`, `updated_at`) VALUES
(1, '2025-03-21', 'mother day', 1, '2025-03-22 04:24:15', '2025-03-22 04:24:15');

-- --------------------------------------------------------

--
-- Table structure for table `institutes`
--

CREATE TABLE `institutes` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `institute_name` varchar(255) NOT NULL,
  `institute_description` text DEFAULT NULL,
  `about_us` varchar(255) DEFAULT NULL,
  `about_image` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `institutes`
--

INSERT INTO `institutes` (`id`, `institute_name`, `institute_description`, `about_us`, `about_image`, `address`, `phone`, `email`, `created_at`, `updated_at`) VALUES
(1, 'معهد التعليم اولا', '\r\nمستقبلك في يديك. يفتح معهدنا ابوابا جديدة لعالم ملئ بالفرص تعلم اللغات الحديثة ،اكتشف اسرار الحاسوب، واكتشف مهارات الادارة التي ستجعلك قائدا في مجالك، نحن نؤمن انك قادر على تحقيق كلما تطمح الية.\r\n', '', 'logo1.png', 'ee', '4444444', 'fi@gmail.com', NULL, '2025-03-10 11:54:30');

-- --------------------------------------------------------

--
-- Table structure for table `invoices`
--

CREATE TABLE `invoices` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `payment_sources_id` bigint(20) UNSIGNED DEFAULT NULL,
  `student_id` bigint(20) UNSIGNED NOT NULL,
  `amount` bigint(20) UNSIGNED NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `invoice_number` varchar(255) NOT NULL,
  `invoice_details` varchar(255) NOT NULL,
  `due_date` date DEFAULT NULL,
  `paid_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `invoices`
--

INSERT INTO `invoices` (`id`, `payment_sources_id`, `student_id`, `amount`, `status`, `invoice_number`, `invoice_details`, `due_date`, `paid_at`, `created_at`, `updated_at`) VALUES
(1, NULL, 4, 10000, 0, 'INV-1742992426', 'رسوم الكورس: بايثون', '2025-04-02', NULL, '2025-03-26 09:33:46', '2025-03-26 09:33:46'),
(2, NULL, 4, 10000, 1, 'INV-1742993151', 'رسوم الكورس: بايثون', '2025-04-02', NULL, '2025-03-26 09:45:51', '2025-03-26 09:45:51'),
(3, NULL, 17, 10000, 0, '251742994142', 'رسوم الكورس: بايثون', '2025-03-26', NULL, '2025-03-26 10:02:22', '2025-03-26 10:02:22');

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_10_12_000000_create_users_table', 1),
(2, '2014_10_12_100000_create_password_reset_tokens_table', 1),
(3, '2019_08_19_000000_create_failed_jobs_table', 1),
(4, '2019_12_14_000001_create_personal_access_tokens_table', 1),
(5, '2024_12_26_071213_create_students_table', 1),
(6, '2024_12_26_072451_create_employees_table', 1),
(7, '2024_12_26_073731_add_user_id_to_students_table', 1),
(8, '2024_12_26_074345_add_user_id_to_employees_table', 1),
(9, '2024_12_26_074858_create_courses_table', 1),
(10, '2024_12_26_075010_create_departments_table', 1),
(11, '2024_12_26_080058_create_course_prices_table', 1),
(12, '2024_12_26_081237_create_advertisements_table', 1),
(13, '2024_12_26_081645_create_student_notifications_table', 1),
(14, '2024_12_26_085117_create_teacher_evaluations_table', 1),
(15, '2024_12_26_090328_create_qualifications_table', 1),
(16, '2024_12_26_114441_create_course_sessions_table', 1),
(17, '2024_12_26_120303_create_course_session_students_table', 1),
(18, '2024_12_26_130631_create_invoices_table', 1),
(19, '2024_12_26_140408_create_payment_sources_table', 1),
(20, '2024_12_26_141721_add_session_id_to_course_prices_table', 1),
(21, '2024_12_26_142859_create_attendances_table', 1),
(22, '2024_12_26_172012_create_institutes_table', 1),
(23, '2024_12_26_184913_add_payment_sources_id_to_invoices_table', 1),
(24, '2024_12_26_185653_create_payments_table', 1),
(25, '2024_12_27_132316_add_department_id_to_courses_table', 1),
(26, '2025_01_02_125212_create_permission_tables', 1),
(27, '2025_03_04_071056_create_holidays_table', 1),
(28, '2025_03_08_112145_create_degrees_table', 1),
(29, '2025_03_08_114757_create_course_evaluations_table', 1),
(30, '2025_03_08_141759_create_course_students_table', 1);

-- --------------------------------------------------------

--
-- Table structure for table `model_has_permissions`
--

CREATE TABLE `model_has_permissions` (
  `permission_id` bigint(20) UNSIGNED NOT NULL,
  `model_type` varchar(255) NOT NULL,
  `model_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `model_has_roles`
--

CREATE TABLE `model_has_roles` (
  `role_id` bigint(20) UNSIGNED NOT NULL,
  `model_type` varchar(255) NOT NULL,
  `model_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `model_has_roles`
--

INSERT INTO `model_has_roles` (`role_id`, `model_type`, `model_id`) VALUES
(1, 'App\\Models\\User', 1),
(1, 'App\\Models\\User', 9),
(1, 'App\\Models\\User', 10),
(2, 'App\\Models\\User', 1),
(2, 'App\\Models\\User', 2),
(2, 'App\\Models\\User', 4),
(2, 'App\\Models\\User', 5),
(2, 'App\\Models\\User', 6),
(2, 'App\\Models\\User', 7),
(2, 'App\\Models\\User', 8),
(2, 'App\\Models\\User', 20),
(3, 'App\\Models\\User', 3),
(3, 'App\\Models\\User', 9),
(3, 'App\\Models\\User', 11),
(3, 'App\\Models\\User', 12),
(3, 'App\\Models\\User', 13),
(3, 'App\\Models\\User', 14),
(3, 'App\\Models\\User', 15),
(3, 'App\\Models\\User', 16),
(3, 'App\\Models\\User', 17),
(3, 'App\\Models\\User', 18),
(3, 'App\\Models\\User', 19),
(3, 'App\\Models\\User', 21),
(3, 'App\\Models\\User', 22),
(3, 'App\\Models\\User', 23),
(3, 'App\\Models\\User', 24),
(3, 'App\\Models\\User', 25),
(3, 'App\\Models\\User', 26),
(3, 'App\\Models\\User', 27);

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `student_id` bigint(20) UNSIGNED NOT NULL,
  `session_id` bigint(20) UNSIGNED DEFAULT NULL,
  `invoice_id` bigint(20) UNSIGNED NOT NULL,
  `status` enum('pending','completed','failed') NOT NULL,
  `payment_date` date NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`id`, `student_id`, `session_id`, `invoice_id`, `status`, `payment_date`, `amount`, `created_at`, `updated_at`) VALUES
(1, 4, 1, 1, 'pending', '2025-03-26', 555.00, '2025-03-26 09:33:46', '2025-03-26 09:33:46'),
(2, 4, 2, 2, 'completed', '2025-03-26', 500.00, '2025-03-26 09:45:51', '2025-03-26 09:45:51'),
(3, 17, NULL, 3, 'completed', '2025-03-26', 566.00, '2025-03-26 10:02:22', '2025-03-26 10:02:22');

-- --------------------------------------------------------

--
-- Table structure for table `payment_sources`
--

CREATE TABLE `payment_sources` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `permissions`
--

CREATE TABLE `permissions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `guard_name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `qualifications`
--

CREATE TABLE `qualifications` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `employee_id` bigint(20) UNSIGNED NOT NULL,
  `qualification_name` varchar(255) NOT NULL,
  `issuing_authority` varchar(255) NOT NULL,
  `certification` varchar(255) DEFAULT NULL,
  `obtained_date` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `qualifications`
--

INSERT INTO `qualifications` (`id`, `employee_id`, `qualification_name`, `issuing_authority`, `certification`, `obtained_date`, `created_at`, `updated_at`) VALUES
(1, 1, 'dd', 'dd', NULL, NULL, '2025-03-09 20:45:57', '2025-03-09 20:45:57'),
(4, 2, 'ffffff', 'ddd', NULL, '2025-02-26', '2025-03-09 21:56:46', '2025-03-09 21:56:46'),
(5, 2, 'ggg', 'hhh', NULL, '2025-03-13', '2025-03-09 21:56:46', '2025-03-09 21:56:46'),
(6, 4, 'ff', 'ffffff', NULL, '2025-02-25', '2025-03-09 22:16:34', '2025-03-09 22:16:34'),
(7, 5, 'ffffff', 'ddd', NULL, '2025-03-03', '2025-03-21 11:26:38', '2025-03-21 11:26:38');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `guard_name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`, `guard_name`, `created_at`, `updated_at`) VALUES
(1, 'admin', 'web', '2025-03-09 18:02:41', '2025-03-09 18:02:41'),
(2, 'teacher', 'web', '2025-03-09 18:02:41', '2025-03-09 18:02:41'),
(3, 'student', 'web', '2025-03-09 18:02:41', '2025-03-09 18:02:41');

-- --------------------------------------------------------

--
-- Table structure for table `role_has_permissions`
--

CREATE TABLE `role_has_permissions` (
  `permission_id` bigint(20) UNSIGNED NOT NULL,
  `role_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

CREATE TABLE `students` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `student_name_en` varchar(300) NOT NULL,
  `student_name_ar` varchar(300) NOT NULL,
  `image` varchar(500) DEFAULT NULL,
  `phones` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`phones`)),
  `gender` enum('male','female') NOT NULL,
  `qualification` varchar(255) NOT NULL,
  `birth_date` date NOT NULL,
  `birth_place` varchar(255) NOT NULL,
  `address` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `state` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `students`
--

INSERT INTO `students` (`id`, `user_id`, `student_name_en`, `student_name_ar`, `image`, `phones`, `gender`, `qualification`, `birth_date`, `birth_place`, `address`, `email`, `state`, `created_at`, `updated_at`) VALUES
(1, 9, 'al sadelawzah saleh', 'لوزة صالح', NULL, NULL, 'female', 'ggggggggg', '2025-02-26', 'ebb', 'sanrraa', 'lawzah.s.alsade@gmail.com', 1, '2025-03-10 07:41:22', '2025-03-10 07:41:22'),
(2, 11, 'al sadelawzah saleh', 'لوزة صالح', NULL, NULL, 'female', 'ggggggggg', '2025-02-26', 'ebb', 'sanrraa', 'lawzah.s.agglsade@gmail.com', 1, '2025-03-10 07:44:56', '2025-03-10 07:44:56'),
(3, 12, ' safaa Dhiab', 'صفاء ذياب', 'login.png', '6666', 'female', 'fff', '2025-02-24', 'ebb', 'Sanaa ', 's@gmail.com', 1, '2025-03-10 07:48:13', '2025-04-06 20:33:17'),
(4, 13, 'al sadelawzah saleh', 'لوزة صالح', NULL, NULL, 'female', 'rrrr', '2025-02-25', 'sanaa', 'sanaa', 'lawzah.s.dsalsade@gmail.com', 1, '2025-03-10 08:17:11', '2025-03-10 08:17:11'),
(5, 14, 'wzah saleh', 'لوزة ص', NULL, '444', 'female', 'dddd', '2025-02-26', 'ebb', 'r', 'a@gmail.com', 1, '2025-03-10 08:22:02', '2025-04-05 17:20:23'),
(6, 15, 'al sadelawzah saleh', 'لوزة صالح الصعديلوزة صالح الصعدي', NULL, NULL, 'female', 'ggggggggg', '2025-02-25', 'sanna', 'sanrraa', 'lawzahsasa@gmail.com', 1, '2025-03-10 08:35:26', '2025-03-10 08:35:26'),
(7, 16, 'lawzah saleh', 'لوزة صالح', NULL, NULL, 'female', 'صصصdddd', '2025-02-26', 'ebb', 'sanrraa', 'lawzahsasr@gmail.com', 1, '2025-03-10 08:37:24', '2025-03-10 08:37:24'),
(8, 17, 'lawzah saleh', 'لوزة صالح', NULL, NULL, 'female', 'صصصdddd', '2025-02-26', 'ebb', 'sanrraa', 'lawddzahsasr@gmail.com', 1, '2025-03-10 08:44:41', '2025-03-10 08:44:41'),
(9, 18, 'al sadelawzah saleh', 'لوزة صالح', NULL, NULL, 'female', 'ggggggggg', '2025-02-25', 'sanna', 'sanrraa', 'lawzasshsa@gmail.com', 1, '2025-03-10 08:53:32', '2025-03-10 08:53:32'),
(10, 19, 'al sadelawzah saleh', 'لوزة صالح الصعدي', NULL, NULL, 'female', 'dddd', '2025-03-06', 'ebb', 'sanrraa', 'lawzahhhh@gmail.com', 1, '2025-03-10 15:46:18', '2025-03-10 15:46:18'),
(11, 21, 'lawzah saleh', 'لوزة صالح علي حسن الصعدي', NULL, '[\"2222222222\"]', 'female', 'ggggggggg', '2025-03-01', 'sanna', 'sanrraa', 'lawzah.sss.alsade@gmail.com', 1, '2025-03-26 04:38:01', '2025-03-26 04:38:01'),
(12, 22, 'kanan saleh', 'كنان الصعدي', NULL, '[\"3333333\"]', 'male', 'dddd', '2025-03-22', 'sanna', 'sanaa', 'kanan@example.com', 1, '2025-03-26 08:45:25', '2025-03-26 08:45:25'),
(13, 23, 'kanan saleh', 'كنان الصعدي', NULL, '[\"3333333\"]', 'male', 'dddd', '2025-03-22', 'sanna', 'sanaa', 'kanannn@example.com', 1, '2025-03-26 08:58:04', '2025-03-26 08:58:04'),
(14, 24, 'kanan saleh', 'كنان الصعدي', NULL, '[\"666666\"]', 'male', 'dddd', '2025-03-22', 'sanna', 'sanaa', 'kanannnnn@example.com', 1, '2025-03-26 09:00:21', '2025-03-26 09:00:21'),
(15, 25, 'kanan saleh', 'كنان الصعدي', NULL, '[\"5555555555\"]', 'male', 'dddd', '2025-03-22', 'sanna', 'sanaa', 'kanannnn@example.com', 1, '2025-03-26 09:33:46', '2025-03-26 09:33:46'),
(16, 26, 'lawzah saleh', 'لوزة صالح علي حسن الصعدي', NULL, '[\"222222222\"]', 'female', 'سسسسسسس', '2025-03-04', 'ebb', 'sanrraa', 'lawzaha@gmail.com', 1, '2025-03-26 09:45:51', '2025-03-26 09:45:51'),
(17, 27, 'kanan saleh', 'لوزة صالح علي حسن الصعدي', NULL, '[\"3333333333\",\"4444444444\"]', 'female', 'قققققققق', '2025-03-03', 'ebbd', 'سعوان', 'lawzah.alsade@gmail.com', 1, '2025-03-26 10:02:22', '2025-03-26 10:02:22');

-- --------------------------------------------------------

--
-- Table structure for table `student_notifications`
--

CREATE TABLE `student_notifications` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `student_id` bigint(20) UNSIGNED NOT NULL,
  `note` text NOT NULL,
  `state` enum('unread','read') NOT NULL DEFAULT 'unread',
  `date` date NOT NULL DEFAULT '2025-03-08',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `student_notifications`
--

INSERT INTO `student_notifications` (`id`, `student_id`, `note`, `state`, `date`, `created_at`, `updated_at`) VALUES
(1, 4, 'you are excellent ', 'read', '2025-03-08', NULL, NULL),
(2, 4, 'ادفع اللي باقي عليك', 'read', '2025-03-08', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `teacher_evaluations`
--

CREATE TABLE `teacher_evaluations` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `student_id` bigint(20) UNSIGNED NOT NULL,
  `employee_id` bigint(20) UNSIGNED NOT NULL,
  `rating` int(11) NOT NULL,
  `feedback` text DEFAULT NULL,
  `date` date NOT NULL DEFAULT '2025-03-08',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Admin User', 'admin@example.com', NULL, '$2y$12$zRAtqKqTm9wxf9oS4ZWD/.FS5A9L5wyg1tcEZVkKlddbS9GF0hxgW', NULL, '2025-03-09 18:02:04', '2025-03-09 18:02:04'),
(2, 'Teacher User', 'teacher@example.com', NULL, '$2y$12$5Aeu9mKXY/XpQOHZnAcLz.eNPXwW6n80373eBKzsOpZm4Zq5GPdf.', NULL, '2025-03-09 18:02:26', '2025-03-09 18:02:26'),
(3, 'Student User', 'student@example.com', NULL, '$2y$12$OxXb8rJb5HGbczIWnH94Qu4/kfTHMpk71MA57aDi4pJLtKxxNo2bG', NULL, '2025-03-09 18:02:32', '2025-03-09 18:02:32'),
(4, 'لوزة الصعدي', 'lawzah@gmail.com', NULL, '$2y$12$G3dMSFSXhebemkAPig7Ze.WNgVPCUJ0NOw6HAFo5rxqrCGcm1uVUS', NULL, '2025-03-09 20:17:19', '2025-03-09 20:17:19'),
(5, 'لوزة الصعدي', 'lawdzah@gmail.com', NULL, '$2y$12$VIxCqhTo0.m2N9Y3J8aUeumUxIN/SNgOgrRM14EN3eS6YtNqpvuou', NULL, '2025-03-09 20:41:53', '2025-03-09 20:41:53'),
(6, 'lawzah', 'laawdzah@gmail.com', NULL, '$2y$12$bw2vZUEXMNde2qeaDFK0f.JI6X/sEQeeoRT3ZyRauSwaK8gyBPU5G', NULL, '2025-03-09 20:45:04', '2025-03-09 20:45:04'),
(7, 'lawzah', 'laawddzah@gmail.com', NULL, '$2y$12$JNDXxLFqDbcvnEmQ53sGSO5iDtxhJGxV8WR4.z1v2EVYN6ntYRa8.', NULL, '2025-03-09 20:45:57', '2025-03-09 20:45:57'),
(8, 'lawzah', 'lawzahsa@gmail.com', NULL, '$2y$12$iHy1SVrTPRWpJ0yWBo.FQewEYCbSBkSRKtv50QKVKC.FzeUHHMQVO', NULL, '2025-03-09 21:44:21', '2025-03-09 21:44:21'),
(9, 'lawzah saleh', 'lawzah.s.alsade@gmail.com', NULL, '$2y$12$dxKfZXg6PR5MbRJcn6UX8Ovmqrhkp91gX/qWVOID7lEBKJu0CGWFq', NULL, '2025-03-09 22:05:33', '2025-03-09 22:05:33'),
(10, 'lawzah saleh', 'eygEfvil@gmail.com', NULL, '$2y$12$eIuBskeTM1B9TMbzeI0HhO7pOJkSx11udyCgxGBcFX739w6xQ8dcq', NULL, '2025-03-09 22:16:34', '2025-03-09 22:16:34'),
(11, 'al sadelawzah saleh', 'lawzah.s.agglsade@gmail.com', NULL, '$2y$12$nuHq89fDeaaDG/11bt2fjuqezZSGjM48.g1ml7McjBJJFDvnAuI0W', NULL, '2025-03-10 07:44:56', '2025-03-10 07:44:56'),
(12, 'al sadelawzah saleh', 'safaa@gmail.com', NULL, '$2y$12$R8oLLZ5P4oWbfQQDOxmmI.1MLsA/RE2NIghsNgyc7FX0vxlGjbwyu', NULL, '2025-03-10 07:48:13', '2025-03-22 05:50:00'),
(13, 'al sadelawzah saleh', 'safa@gmail.com', NULL, '$2y$12$H1UQD3UO6AZ14hQKtPIKrufwCcOHJ8ggLhXqUOAep2ZfC6REC.j3.', NULL, '2025-03-10 08:17:11', '2025-03-10 08:17:11'),
(14, 'al sadelawzah saleh', 'lawddzahsa@gmail.com', NULL, '$2y$12$H7rr98TW8YD9hFimsdoVD.hewYnDOWBbUBJDDNZsu5jmekd89jmPO', NULL, '2025-03-10 08:22:02', '2025-03-10 08:22:02'),
(15, 'al sadelawzah saleh', 'lawzahsasa@gmail.com', NULL, '$2y$12$ydM8HCJsnaiS.wWEt1OVdehIJulJDyoVT3GwVpd/bER.GmmLBBi42', NULL, '2025-03-10 08:35:26', '2025-03-10 08:35:26'),
(16, 'lawzah saleh', 'lawzahsasr@gmail.com', NULL, '$2y$12$8ds9orhLQloP8B4UA/iLv.JI1rVYpnhk6C6NoDNvWaMCiBGqldPMa', NULL, '2025-03-10 08:37:24', '2025-03-10 08:37:24'),
(17, 'lawzah saleh', 'lawddzahsasr@gmail.com', NULL, '$2y$12$tJ0YWERkKuNovhHMxReJTeUbjHGmwntle./YzvWD/Uql6JnClfUAm', NULL, '2025-03-10 08:44:41', '2025-03-10 08:44:41'),
(18, 'al sadelawzah saleh', 'lawzasshsa@gmail.com', NULL, '$2y$12$MpHuQ3E5esScbEA7rGGCeeJ8.raZVSUgZwn3QKnnKhpERZYAIGNte', NULL, '2025-03-10 08:53:32', '2025-03-10 08:53:32'),
(19, 'al sadelawzah saleh', 'lawzahhhh@gmail.com', NULL, '$2y$12$jMIun3H8wGlG.sPMbmtrf.5huzX1cMMxSKkv/sBROmxh19fLK93Ja', NULL, '2025-03-10 15:46:18', '2025-03-10 15:46:18'),
(20, 'lawzah', 'lawzahteacher@gmail.com', NULL, '$2y$12$qfqNdZsPVDg.Q01SV9MRbe/IjiX6LiZx7XuYhQqmXdFaa.gaQxnQi', NULL, '2025-03-21 11:26:38', '2025-03-21 11:26:38'),
(21, 'lawzah saleh', 'lawzah.sss.alsade@gmail.com', NULL, '$2y$12$qsFpAkQRrpoGB3IBhdTch.pUDpnVU8Grf9bWV8Pk1lEGgssnyuJcy', NULL, '2025-03-26 04:38:01', '2025-03-26 04:38:01'),
(22, 'kanan saleh', 'kanan@example.com', NULL, '$2y$12$II.VTRhZmpgkixdfdNCZsO1ZQ78BmpbjLPfNa3PSRU5bn.DuSKPvy', NULL, '2025-03-26 08:45:25', '2025-03-26 08:45:25'),
(23, 'kanan saleh', 'kanannn@example.com', NULL, '$2y$12$1owYWCl15PLqtiiOBjNw/erOpzhRt9LadaQXaHC.eqid9yjVrFPvW', NULL, '2025-03-26 08:58:04', '2025-03-26 08:58:04'),
(24, 'kanan saleh', 'kanannnnn@example.com', NULL, '$2y$12$cfztKBKTpXQaPFE5A9nq..c3jD.g5GNdEdO1Dmrp/Gk7okYh7xk/a', NULL, '2025-03-26 09:00:21', '2025-03-26 09:00:21'),
(25, 'kanan saleh', 'kanannnn@example.com', NULL, '$2y$12$NJBCzSR7vk5fmN6W.tlcjeli9d.GTthSJIo9.LVFTmhfPAHqHSgom', NULL, '2025-03-26 09:33:46', '2025-03-26 09:33:46'),
(26, 'lawzah saleh', 'lawzaha@gmail.com', NULL, '$2y$12$U2VTJswAj0IRciQuZ1N/s.Z7y3AeuQMb1fbuYXrciJiEiyf5y0cWS', NULL, '2025-03-26 09:45:51', '2025-03-26 09:45:51'),
(27, 'kanan saleh', 'lawzah.alsade@gmail.com', NULL, '$2y$12$CQmJ/aCXMs1r1AlXBl3RhOx5SeiOiMomBSc4kgmQ9Tq9QklGEvTPe', NULL, '2025-03-26 10:02:22', '2025-03-26 10:02:22');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `advertisements`
--
ALTER TABLE `advertisements`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `attendances`
--
ALTER TABLE `attendances`
  ADD PRIMARY KEY (`id`),
  ADD KEY `attendances_student_id_foreign` (`student_id`),
  ADD KEY `attendances_session_id_foreign` (`session_id`),
  ADD KEY `attendances_employee_id_foreign` (`employee_id`);

--
-- Indexes for table `courses`
--
ALTER TABLE `courses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `courses_department_id_foreign` (`department_id`);

--
-- Indexes for table `course_evaluations`
--
ALTER TABLE `course_evaluations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `course_evaluations_student_id_course_session_id_unique` (`student_id`,`course_session_id`),
  ADD KEY `course_evaluations_course_session_id_foreign` (`course_session_id`);

--
-- Indexes for table `course_prices`
--
ALTER TABLE `course_prices`
  ADD PRIMARY KEY (`id`),
  ADD KEY `course_prices_course_id_foreign` (`course_id`),
  ADD KEY `course_prices_session_id_foreign` (`session_id`);

--
-- Indexes for table `course_sessions`
--
ALTER TABLE `course_sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `course_sessions_course_id_foreign` (`course_id`),
  ADD KEY `course_sessions_employee_id_foreign` (`employee_id`);

--
-- Indexes for table `course_session_students`
--
ALTER TABLE `course_session_students`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `course_session_students_student_id_course_session_id_unique` (`student_id`,`course_session_id`),
  ADD KEY `course_session_students_course_session_id_foreign` (`course_session_id`);

--
-- Indexes for table `course_students`
--
ALTER TABLE `course_students`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `course_students_student_id_course_id_unique` (`student_id`,`course_id`),
  ADD KEY `course_students_course_id_foreign` (`course_id`);

--
-- Indexes for table `degrees`
--
ALTER TABLE `degrees`
  ADD PRIMARY KEY (`id`),
  ADD KEY `degrees_student_id_index` (`student_id`),
  ADD KEY `degrees_course_session_id_index` (`course_session_id`);

--
-- Indexes for table `departments`
--
ALTER TABLE `departments`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `employees`
--
ALTER TABLE `employees`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `employees_email_unique` (`email`),
  ADD KEY `employees_user_id_foreign` (`user_id`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `holidays`
--
ALTER TABLE `holidays`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `holidays_date_unique` (`date`);

--
-- Indexes for table `institutes`
--
ALTER TABLE `institutes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `invoices`
--
ALTER TABLE `invoices`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `invoices_invoice_number_unique` (`invoice_number`),
  ADD KEY `invoices_student_id_foreign` (`student_id`),
  ADD KEY `invoices_payment_sources_id_foreign` (`payment_sources_id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `model_has_permissions`
--
ALTER TABLE `model_has_permissions`
  ADD PRIMARY KEY (`permission_id`,`model_id`,`model_type`),
  ADD KEY `model_has_permissions_model_id_model_type_index` (`model_id`,`model_type`);

--
-- Indexes for table `model_has_roles`
--
ALTER TABLE `model_has_roles`
  ADD PRIMARY KEY (`role_id`,`model_id`,`model_type`),
  ADD KEY `model_has_roles_model_id_model_type_index` (`model_id`,`model_type`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `payments_student_id_foreign` (`student_id`),
  ADD KEY `payments_session_id_foreign` (`session_id`),
  ADD KEY `payments_invoice_id_foreign` (`invoice_id`);

--
-- Indexes for table `payment_sources`
--
ALTER TABLE `payment_sources`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `permissions_name_guard_name_unique` (`name`,`guard_name`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Indexes for table `qualifications`
--
ALTER TABLE `qualifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `qualifications_employee_id_foreign` (`employee_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `roles_name_guard_name_unique` (`name`,`guard_name`);

--
-- Indexes for table `role_has_permissions`
--
ALTER TABLE `role_has_permissions`
  ADD PRIMARY KEY (`permission_id`,`role_id`),
  ADD KEY `role_has_permissions_role_id_foreign` (`role_id`);

--
-- Indexes for table `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `students_email_unique` (`email`),
  ADD KEY `students_student_name_en_index` (`student_name_en`),
  ADD KEY `students_student_name_ar_index` (`student_name_ar`),
  ADD KEY `students_user_id_foreign` (`user_id`);

--
-- Indexes for table `student_notifications`
--
ALTER TABLE `student_notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `student_notifications_student_id_foreign` (`student_id`);

--
-- Indexes for table `teacher_evaluations`
--
ALTER TABLE `teacher_evaluations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `teacher_evaluations_student_id_foreign` (`student_id`),
  ADD KEY `teacher_evaluations_employee_id_foreign` (`employee_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `advertisements`
--
ALTER TABLE `advertisements`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `attendances`
--
ALTER TABLE `attendances`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=154;

--
-- AUTO_INCREMENT for table `courses`
--
ALTER TABLE `courses`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `course_evaluations`
--
ALTER TABLE `course_evaluations`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `course_prices`
--
ALTER TABLE `course_prices`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `course_sessions`
--
ALTER TABLE `course_sessions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `course_session_students`
--
ALTER TABLE `course_session_students`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `course_students`
--
ALTER TABLE `course_students`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `degrees`
--
ALTER TABLE `degrees`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `departments`
--
ALTER TABLE `departments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `employees`
--
ALTER TABLE `employees`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `holidays`
--
ALTER TABLE `holidays`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `institutes`
--
ALTER TABLE `institutes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `invoices`
--
ALTER TABLE `invoices`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `payment_sources`
--
ALTER TABLE `payment_sources`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `qualifications`
--
ALTER TABLE `qualifications`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `students`
--
ALTER TABLE `students`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `student_notifications`
--
ALTER TABLE `student_notifications`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `teacher_evaluations`
--
ALTER TABLE `teacher_evaluations`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `attendances`
--
ALTER TABLE `attendances`
  ADD CONSTRAINT `attendances_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `attendances_session_id_foreign` FOREIGN KEY (`session_id`) REFERENCES `course_sessions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `attendances_student_id_foreign` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `courses`
--
ALTER TABLE `courses`
  ADD CONSTRAINT `courses_department_id_foreign` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `course_evaluations`
--
ALTER TABLE `course_evaluations`
  ADD CONSTRAINT `course_evaluations_course_session_id_foreign` FOREIGN KEY (`course_session_id`) REFERENCES `course_sessions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `course_evaluations_student_id_foreign` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `course_prices`
--
ALTER TABLE `course_prices`
  ADD CONSTRAINT `course_prices_course_id_foreign` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `course_prices_session_id_foreign` FOREIGN KEY (`session_id`) REFERENCES `course_sessions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `course_sessions`
--
ALTER TABLE `course_sessions`
  ADD CONSTRAINT `course_sessions_course_id_foreign` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `course_sessions_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `course_session_students`
--
ALTER TABLE `course_session_students`
  ADD CONSTRAINT `course_session_students_course_session_id_foreign` FOREIGN KEY (`course_session_id`) REFERENCES `course_sessions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `course_session_students_student_id_foreign` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `course_students`
--
ALTER TABLE `course_students`
  ADD CONSTRAINT `course_students_course_id_foreign` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `course_students_student_id_foreign` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `degrees`
--
ALTER TABLE `degrees`
  ADD CONSTRAINT `degrees_course_session_id_foreign` FOREIGN KEY (`course_session_id`) REFERENCES `course_sessions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `degrees_student_id_foreign` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `employees`
--
ALTER TABLE `employees`
  ADD CONSTRAINT `employees_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `invoices`
--
ALTER TABLE `invoices`
  ADD CONSTRAINT `invoices_payment_sources_id_foreign` FOREIGN KEY (`payment_sources_id`) REFERENCES `payment_sources` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `invoices_student_id_foreign` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `model_has_permissions`
--
ALTER TABLE `model_has_permissions`
  ADD CONSTRAINT `model_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `model_has_roles`
--
ALTER TABLE `model_has_roles`
  ADD CONSTRAINT `model_has_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_invoice_id_foreign` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `payments_session_id_foreign` FOREIGN KEY (`session_id`) REFERENCES `course_sessions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `payments_student_id_foreign` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `qualifications`
--
ALTER TABLE `qualifications`
  ADD CONSTRAINT `qualifications_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `role_has_permissions`
--
ALTER TABLE `role_has_permissions`
  ADD CONSTRAINT `role_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `role_has_permissions_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `students`
--
ALTER TABLE `students`
  ADD CONSTRAINT `students_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `student_notifications`
--
ALTER TABLE `student_notifications`
  ADD CONSTRAINT `student_notifications_student_id_foreign` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `teacher_evaluations`
--
ALTER TABLE `teacher_evaluations`
  ADD CONSTRAINT `teacher_evaluations_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `teacher_evaluations_student_id_foreign` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
