-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: proxysql-01.dd.scip.local
-- Tiempo de generación: 24-01-2025 a las 08:39:45
-- Versión del servidor: 10.10.7-MariaDB-1:10.10.7+maria~deb11
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `ddb244825`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `activity_log`
--

CREATE TABLE `activity_log` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `action_type` varchar(50) NOT NULL,
  `action_details` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `appointments`
--

CREATE TABLE `appointments` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `lead_id` int(11) DEFAULT NULL,
  `property_id` int(11) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `appointment_type` enum('visita','llamada','firma','valoracion') NOT NULL,
  `start_time` datetime NOT NULL,
  `end_time` datetime NOT NULL,
  `notes` text DEFAULT NULL,
  `status` enum('pendiente','completada','cancelada') DEFAULT 'pendiente',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `communication_history`
--

CREATE TABLE `communication_history` (
  `id` int(11) NOT NULL,
  `lead_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `type` varchar(50) NOT NULL,
  `description` text NOT NULL,
  `contact_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `communication_history`
--

INSERT INTO `communication_history` (`id`, `lead_id`, `user_id`, `type`, `description`, `contact_date`) VALUES
(1, 160, 0, 'call', '1', '2025-01-18 07:24:07'),
(2, 160, 0, 'whatsapp', '1', '2025-01-18 07:25:07'),
(3, 160, 0, 'visit', 'cafe', '2025-01-18 07:25:17'),
(4, 160, 0, 'call', '3', '2025-01-18 07:32:20'),
(5, 160, 0, 'other', 'hemos hecho meets y es el mejor', '2025-01-18 07:34:07'),
(6, 218, 6, 'call', 'DATOS FALSOS. DESCUALIFICO', '2025-01-21 13:48:19'),
(7, 148, 6, 'call', '20/1 LLAMADA, PREFIERE RECIBIR INFO Y POSPONER LLAMADA UNA VEZ HAYA REVISADO TODO.', '2025-01-21 14:30:57'),
(8, 148, 6, 'email', '21/01 ENVIO MAIL\r\n', '2025-01-21 14:31:13'),
(9, 219, 6, 'call', 'agendado tras wp inmediato, envío info por mail.', '2025-01-21 19:00:05'),
(10, 219, 6, 'visit', 'habrá reunión presencial con Roger ya que es el propietario de la marca de todo tipo de bebidas de Camiño dos Faros.', '2025-01-21 19:34:06'),
(11, 262, 6, 'call', 'tfn erroneo, enviado mail para agendar llamada posterior', '2025-01-21 23:05:35'),
(12, 209, 6, 'call', 'enviado mail ya que tfn erroneo', '2025-01-21 23:07:45'),
(13, 260, 6, 'call', 'enviado mail, no tiene wp', '2025-01-21 23:11:31'),
(14, 217, 6, 'call', 'enviado mail, no tiene wp\r\n', '2025-01-21 23:12:07'),
(15, 208, 6, 'call', 'llamo a hora acordada pero no responde. envio mail y reagendo', '2025-01-22 14:32:19'),
(16, 263, 6, 'call', 'no atiende llamada programada, envio mail y reagendo.', '2025-01-22 14:35:49'),
(17, 337, 6, 'call', 'Contrato por 25k firmado', '2025-01-22 18:59:47'),
(18, 337, 6, 'call', 'Pdte justificante de transfer\r\n', '2025-01-22 19:00:08'),
(19, 337, 6, 'call', 'cerrados 25.000$', '2025-01-22 20:55:54'),
(20, 144, 6, 'call', 'programada llamada para 23/1 a las 10:00', '2025-01-22 22:18:39'),
(21, 145, 6, 'call', 'programada llamada para viernes 11:30h. ', '2025-01-22 22:20:15'),
(22, 145, 6, 'email', 'envio mail con info previo a llamada', '2025-01-22 22:20:30'),
(23, 342, 6, 'call', 'programada llamada para 23/1.', '2025-01-22 22:27:53'),
(24, 105, 6, 'email', 'enviados mails desde admision de one de ambos proyectos.', '2025-01-22 22:58:28'),
(25, 344, 6, 'email', 'enviado mail a los dos mails que deja en cntacto. Eze no la contacta en los 1os leads, contacto yo las dos veces que ha solicitado la info.', '2025-01-22 23:27:38'),
(26, 294, 6, 'call', 'enviado mail a los dos mails que deja en cntacto. Eze no la contacta en los 1os leads, contacto yo las dos veces que ha solicitado la info.', '2025-01-22 23:28:30'),
(27, 180, 4, 'call', 'tiene apartamentos turisticos en cangas le preocupa el garantizado quiere ver la documentación', '2025-01-23 09:28:22'),
(28, 362, 6, 'whatsapp', 'enviado wp para programar llamada', '2025-01-23 19:48:36'),
(29, 355, 6, 'whatsapp', 'enviado wp para programar llamada', '2025-01-23 19:51:13'),
(30, 354, 6, 'whatsapp', 'envio wp para progamar llamada', '2025-01-23 19:54:35'),
(31, 351, 6, 'call', 'envio wp para programar la llamada', '2025-01-23 20:44:16'),
(32, 349, 6, 'whatsapp', 'envio wp para programar llamada', '2025-01-23 20:45:12'),
(33, 347, 6, 'whatsapp', 'envio wp para programar llamada', '2025-01-23 20:46:19'),
(34, 345, 6, 'whatsapp', 'ha enviado 5 solicitudes, contactada por sms y por mail', '2025-01-23 20:47:08'),
(35, 346, 6, 'call', 'envio wp para progamar llamada', '2025-01-23 20:48:04');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `follow_ups`
--

CREATE TABLE `follow_ups` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `lead_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `due_date` datetime NOT NULL,
  `status` enum('pending','completed','cancelled') DEFAULT 'pending',
  `priority` enum('low','medium','high') DEFAULT 'medium',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `follow_up_tags`
--

CREATE TABLE `follow_up_tags` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `color` varchar(7) DEFAULT '#666666',
  `user_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `follow_up_tag_relations`
--

CREATE TABLE `follow_up_tag_relations` (
  `follow_up_id` int(11) NOT NULL,
  `tag_id` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `investments`
--

CREATE TABLE `investments` (
  `id` int(11) NOT NULL,
  `lead_id` int(11) NOT NULL,
  `investment_name` varchar(255) NOT NULL,
  `investment_type` enum('inmobiliario','startup','proyecto','fondo') NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `status` enum('pending','active','completed','cancelled') NOT NULL DEFAULT 'pending',
  `roi_percentage` decimal(5,2) DEFAULT NULL,
  `expected_return` decimal(15,2) DEFAULT NULL,
  `current_value` decimal(15,2) DEFAULT NULL,
  `payment_frequency` enum('monthly','quarterly','annual','end_term') NOT NULL,
  `next_payment_date` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `investment_documents`
--

CREATE TABLE `investment_documents` (
  `id` int(11) NOT NULL,
  `investment_id` int(11) NOT NULL,
  `document_name` varchar(255) NOT NULL,
  `document_type` enum('contract','report','receipt','legal','other') NOT NULL,
  `file_path` varchar(255) NOT NULL,
  `is_signed` tinyint(1) DEFAULT 0,
  `requires_signature` tinyint(1) DEFAULT 0,
  `upload_date` timestamp NULL DEFAULT current_timestamp(),
  `uploaded_by` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `investment_payments`
--

CREATE TABLE `investment_payments` (
  `id` int(11) NOT NULL,
  `investment_id` int(11) NOT NULL,
  `payment_date` date NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `status` enum('pending','processing','completed','failed') NOT NULL DEFAULT 'pending',
  `payment_type` enum('interest','principal','both') NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `investment_performance`
--

CREATE TABLE `investment_performance` (
  `id` int(11) NOT NULL,
  `investor_id` int(11) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `value` decimal(10,2) DEFAULT NULL,
  `return_rate` decimal(5,2) DEFAULT NULL,
  `notes` text DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `investment_updates`
--

CREATE TABLE `investment_updates` (
  `id` int(11) NOT NULL,
  `investment_id` int(11) NOT NULL,
  `update_date` timestamp NULL DEFAULT current_timestamp(),
  `update_type` enum('value_change','payment','status_change','document','note') NOT NULL,
  `description` text NOT NULL,
  `value_change` decimal(15,2) DEFAULT NULL,
  `created_by` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `investors`
--

CREATE TABLE `investors` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `investment_amount` decimal(10,2) DEFAULT NULL,
  `investment_date` date DEFAULT NULL,
  `expected_return` decimal(5,2) DEFAULT NULL,
  `project_id` int(11) DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `investors`
--

INSERT INTO `investors` (`id`, `user_id`, `name`, `email`, `phone`, `password`, `investment_amount`, `investment_date`, `expected_return`, `project_id`, `status`, `notes`, `created_at`) VALUES
(3, 3, 'JOSE ANGEL CASTILLO DIEZ', 'josea.castillodiez@gmail.com', '695965126', '$2a$12$24xDCNfAIDyz.smPiprDeu04c0XcWGf3UARk1jOWY539HFo574OZ6', 7000.00, '1998-12-16', 12.00, 3, 'active', '', '2025-01-24 06:45:18');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `investor_documents`
--

CREATE TABLE `investor_documents` (
  `id` int(11) NOT NULL,
  `investor_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `file_path` varchar(255) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `upload_date` datetime DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `investor_notifications`
--

CREATE TABLE `investor_notifications` (
  `id` int(11) NOT NULL,
  `lead_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `type` enum('payment','document','update','alert') NOT NULL,
  `read_status` tinyint(1) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `leads`
--

CREATE TABLE `leads` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `stage_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `source` varchar(50) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `last_contact` timestamp NULL DEFAULT NULL,
  `is_investor` tinyint(1) DEFAULT 0,
  `investor_status` enum('active','inactive') DEFAULT NULL,
  `total_invested` decimal(15,2) DEFAULT 0.00,
  `investment_preferences` text DEFAULT NULL,
  `investor_password` varchar(255) DEFAULT NULL,
  `investor_id` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `leads`
--

INSERT INTO `leads` (`id`, `user_id`, `stage_id`, `name`, `email`, `phone`, `source`, `notes`, `created_at`, `updated_at`, `last_contact`, `is_investor`, `investor_status`, `total_invested`, `investment_preferences`, `investor_password`, `investor_id`) VALUES
(388, 0, 1, 'AA', 'pepa@ar.com', '+34695965122', 'Galicia Glamping - META', '¿HA INVERTIDO ALGUNA VEZ? Si\n\nTIENE: Menos de 5.000 €', '2025-01-24 07:14:41', '2025-01-24 08:37:47', NULL, 0, NULL, 0.00, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `lead_files`
--

CREATE TABLE `lead_files` (
  `id` int(11) NOT NULL,
  `lead_id` int(11) NOT NULL,
  `file_name` varchar(255) NOT NULL,
  `file_path` varchar(255) NOT NULL,
  `original_name` varchar(255) NOT NULL,
  `file_type` varchar(100) NOT NULL,
  `file_size` int(11) NOT NULL,
  `uploaded_by` int(11) NOT NULL,
  `upload_date` timestamp NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `lead_files`
--

INSERT INTO `lead_files` (`id`, `lead_id`, `file_name`, `file_path`, `original_name`, `file_type`, `file_size`, `uploaded_by`, `upload_date`) VALUES
(0, 337, '679140470ed25_ONE_CONTRATO_ARMANI_ROBERTO_RODRIGUEZ_TROYO.pdf', 'uploads/leads/337/679140470ed25_ONE_CONTRATO_ARMANI_ROBERTO_RODRIGUEZ_TROYO.pdf', 'ONE CONTRATO ARMANI ROBERTO RODRIGUEZ TROYO.pdf', 'application/pdf', 275978, 6, '2025-01-22 19:00:23'),
(0, 258, '678f67e2c23da_simulador.png', 'uploads/leads/258/678f67e2c23da_simulador.png', 'simulador.png', 'image/png', 364405, 0, '2025-01-21 09:24:50'),
(0, 160, '678b5ac140e67_one.png', 'uploads/leads/160/678b5ac140e67_one.png', 'one.png', 'image/png', 8496, 0, '2025-01-18 07:39:45'),
(0, 337, '67915b475054a_justificante_25000__Roberto_ARMANI.jpg', 'uploads/leads/337/67915b475054a_justificante_25000__Roberto_ARMANI.jpg', 'justificante 25000$ Roberto ARMANI.jpg', 'image/jpeg', 249592, 6, '2025-01-22 20:55:35'),
(0, 76, '679192c79a519_ARMANI_5.000____FERNANDO_LOPEZ_ENERO__25.pdf', 'uploads/leads/76/679192c79a519_ARMANI_5.000____FERNANDO_LOPEZ_ENERO__25.pdf', 'ARMANI 5.000€ FERNANDO LOPEZ ENERO´25.pdf', 'application/pdf', 1462951, 6, '2025-01-23 00:52:23'),
(0, 76, '679192dee35db_Contrato_1_firmado.pdf', 'uploads/leads/76/679192dee35db_Contrato_1_firmado.pdf', 'Contrato 1 firmado.pdf', 'application/pdf', 2106476, 6, '2025-01-23 00:52:46'),
(0, 76, '679192ea8c2fb_fernando_lopez_ONE_CONTRATO_DE_CUENTAS_EN_PARTICIPACIO_N_MERCANTIL_def_signed.pdf', 'uploads/leads/76/679192ea8c2fb_fernando_lopez_ONE_CONTRATO_DE_CUENTAS_EN_PARTICIPACIO_N_MERCANTIL_def_signed.pdf', 'fernando lopez ONE CONTRATO DE CUENTAS EN PARTICIPACIO_N MERCANTIL_def_signed.pdf', 'application/pdf', 157690, 6, '2025-01-23 00:52:58'),
(0, 76, '679193818a9c1_CONTRATO_FINAL_FERNANDO_FIRMADO.pdf', 'uploads/leads/76/679193818a9c1_CONTRATO_FINAL_FERNANDO_FIRMADO.pdf', 'CONTRATO FINAL FERNANDO FIRMADO.pdf', 'application/pdf', 2490973, 6, '2025-01-23 00:55:29');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `lead_history`
--

CREATE TABLE `lead_history` (
  `id` int(11) NOT NULL,
  `lead_id` int(11) NOT NULL,
  `action_type` varchar(50) DEFAULT NULL,
  `stage_id` int(11) NOT NULL,
  `created_by` int(11) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `changed_at` timestamp NULL DEFAULT current_timestamp(),
  `changed_by` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `lead_history`
--

INSERT INTO `lead_history` (`id`, `lead_id`, `action_type`, `stage_id`, `created_by`, `notes`, `changed_at`, `changed_by`) VALUES
(1, 85, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 4),
(2, 86, 'stage_change', 2, 4, NULL, '2024-10-21 19:47:49', 4),
(3, 15, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(4, 16, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(5, 17, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(6, 18, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(7, 19, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(8, 20, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(9, 21, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(10, 22, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(11, 23, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(12, 24, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(13, 25, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(14, 26, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(15, 27, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(16, 28, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(17, 29, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(18, 30, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(19, 31, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(20, 32, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(21, 33, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(22, 34, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(23, 35, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(24, 36, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(25, 37, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(26, 38, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(27, 39, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(28, 40, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(29, 41, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(30, 42, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(31, 43, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(32, 44, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(33, 45, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(34, 46, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(35, 47, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(36, 48, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(37, 49, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(38, 50, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(39, 51, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(40, 52, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(41, 53, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(42, 54, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(43, 55, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(44, 56, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(45, 57, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(46, 58, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(47, 59, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(48, 60, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(49, 61, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(50, 62, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(51, 63, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(52, 64, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(53, 65, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(54, 66, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(55, 67, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(56, 68, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(57, 69, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(58, 70, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(59, 71, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(60, 72, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(61, 73, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(62, 74, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(63, 75, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(64, 76, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(65, 77, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(66, 78, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(67, 79, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(68, 80, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(69, 81, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(70, 82, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(71, 83, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(72, 84, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(73, 87, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 4),
(74, 88, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 4),
(75, 89, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 4),
(76, 90, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 4),
(77, 91, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 4),
(78, 92, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 4),
(79, 93, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 4),
(80, 94, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 4),
(81, 95, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 4),
(82, 96, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 4),
(83, 97, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 4),
(84, 98, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 4),
(85, 99, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 4),
(86, 100, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 4),
(87, 101, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 4),
(88, 102, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 4),
(89, 103, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 4),
(90, 104, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 4),
(91, 129, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 4),
(92, 133, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 4),
(93, 136, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 3),
(94, 140, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 4),
(95, 199, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 2),
(96, 189, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 4),
(97, 197, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 2),
(98, 198, 'stage_change', 1, 4, NULL, '2024-10-21 19:47:49', 4),
(99, 196, 'stage_change', 6, 4, NULL, '2024-10-21 19:47:49', 2),
(100, 199, 'stage_change', 2, 4, NULL, '2024-10-21 19:51:03', 2),
(101, 199, 'stage_change', 4, 4, NULL, '2024-10-21 19:51:07', 2),
(102, 199, 'stage_change', 6, 4, NULL, '2024-10-21 19:51:14', 2),
(103, 199, 'stage_change', 2, 4, NULL, '2024-10-21 19:51:17', 2),
(104, 199, 'stage_change', 6, 4, NULL, '2024-10-21 19:51:19', 2),
(105, 196, 'stage_change', 2, 4, NULL, '2024-10-21 19:51:22', 2),
(106, 196, 'stage_change', 6, 4, NULL, '2024-10-21 19:51:24', 2),
(107, 197, 'stage_change', 2, 4, NULL, '2024-10-21 19:51:39', 2),
(108, 197, 'stage_change', 4, 4, NULL, '2024-10-21 19:51:44', 2),
(109, 197, 'stage_change', 6, 4, NULL, '2024-10-21 19:51:48', 2),
(110, 200, 'stage_change', 2, 4, NULL, '2024-10-21 19:58:33', 2),
(111, 200, 'stage_change', 4, 4, NULL, '2024-10-21 19:58:35', 2),
(112, 196, 'stage_change', 1, 4, NULL, '2024-10-21 19:58:45', 2),
(113, 196, 'stage_change', 2, 4, NULL, '2024-10-21 19:58:47', 2),
(114, 208, 'stage_change', 2, 4, NULL, '2024-10-22 05:55:39', 2),
(115, 208, 'stage_change', 4, 4, NULL, '2024-10-22 05:55:41', 2),
(116, 214, 'stage_change', 4, 4, NULL, '2024-10-22 05:57:19', 2),
(117, 214, 'stage_change', 1, 4, NULL, '2024-10-22 05:57:26', 2),
(118, 214, 'stage_change', 4, 4, NULL, '2024-10-22 05:57:33', 2),
(119, 214, 'stage_change', 2, 4, NULL, '2024-10-22 05:57:38', 2),
(120, 214, 'stage_change', 4, 4, NULL, '2024-10-22 05:57:39', 2),
(121, 213, 'stage_change', 2, 4, NULL, '2024-10-22 09:44:14', 2),
(122, 213, 'stage_change', 3, 4, NULL, '2024-10-22 09:44:18', 2),
(123, 213, 'stage_change', 4, 4, NULL, '2024-10-22 09:44:21', 2),
(124, 214, 'stage_change', 6, 4, NULL, '2024-10-22 09:44:24', 2),
(125, 213, 'stage_change', 5, 4, NULL, '2024-10-22 09:44:28', 2),
(126, 212, 'stage_change', 1, 4, NULL, '2024-10-22 11:06:15', 2),
(127, 212, 'stage_change', 2, 4, NULL, '2024-10-22 11:06:17', 2),
(128, 212, 'stage_change', 3, 4, NULL, '2024-10-22 11:06:18', 2),
(129, 212, 'stage_change', 3, 4, NULL, '2024-10-22 11:06:19', 2),
(130, 212, 'stage_change', 4, 4, NULL, '2024-10-22 11:06:20', 2),
(131, 410, 'stage_change', 2, 4, NULL, '2024-10-23 09:25:12', 6),
(132, 398, 'stage_change', 2, 4, NULL, '2024-10-23 09:25:32', 6),
(133, 399, 'stage_change', 2, 4, NULL, '2024-10-23 09:25:33', 6),
(134, 400, 'stage_change', 4, 4, NULL, '2024-10-23 09:25:35', 6),
(135, 400, 'stage_change', 1, 4, NULL, '2024-10-23 10:37:13', 6),
(136, 398, 'stage_change', 1, 4, NULL, '2024-10-23 10:37:14', 6),
(137, 410, 'stage_change', 1, 4, NULL, '2024-10-23 10:37:15', 6),
(138, 399, 'stage_change', 1, 4, NULL, '2024-10-23 10:37:16', 6),
(139, 605, 'stage_change', 1, 4, NULL, '2024-10-23 15:36:30', 6),
(140, 605, 'stage_change', 1, 4, NULL, '2024-10-23 15:36:31', 6),
(141, 605, 'stage_change', 2, 4, NULL, '2024-10-23 15:36:32', 6),
(142, 575, 'stage_change', 3, 4, NULL, '2024-10-23 15:36:34', 6),
(143, 574, 'stage_change', 4, 4, NULL, '2024-10-23 15:36:35', 6),
(144, 572, 'stage_change', 4, 4, NULL, '2024-10-23 15:36:38', 6),
(145, 570, 'stage_change', 4, 4, NULL, '2024-10-23 15:36:40', 6),
(146, 136, 'stage_change', 2, 4, NULL, '2024-10-23 15:39:12', 3),
(147, 82, 'stage_change', 2, 4, NULL, '2024-10-23 15:39:13', 3),
(148, 83, 'stage_change', 2, 4, NULL, '2024-10-23 15:39:14', 3),
(149, 84, 'stage_change', 2, 4, NULL, '2024-10-23 15:39:15', 3),
(150, 81, 'stage_change', 2, 4, NULL, '2024-10-23 15:39:16', 3),
(151, 70, 'stage_change', 2, 4, NULL, '2024-10-23 15:39:17', 3),
(152, 71, 'stage_change', 2, 4, NULL, '2024-10-23 15:39:18', 3),
(153, 72, 'stage_change', 3, 4, NULL, '2024-10-23 15:39:20', 3),
(154, 73, 'stage_change', 2, 4, NULL, '2024-10-23 15:39:20', 3),
(155, 74, 'stage_change', 2, 4, NULL, '2024-10-23 15:39:21', 3),
(156, 75, 'stage_change', 2, 4, NULL, '2024-10-23 15:39:23', 3),
(157, 76, 'stage_change', 1, 4, NULL, '2024-10-23 15:39:24', 3),
(158, 76, 'stage_change', 2, 4, NULL, '2024-10-23 15:39:26', 3),
(159, 136, 'stage_change', 3, 4, NULL, '2024-10-23 15:39:27', 3),
(160, 82, 'stage_change', 3, 4, NULL, '2024-10-23 15:39:28', 3),
(161, 83, 'stage_change', 3, 4, NULL, '2024-10-23 15:39:29', 3),
(162, 77, 'stage_change', 3, 4, NULL, '2024-10-23 15:39:30', 3),
(163, 78, 'stage_change', 3, 4, NULL, '2024-10-23 15:39:32', 3),
(164, 84, 'stage_change', 3, 4, NULL, '2024-10-23 15:39:33', 3),
(165, 79, 'stage_change', 4, 4, NULL, '2024-10-23 15:39:35', 3),
(166, 136, 'stage_change', 4, 4, NULL, '2024-10-23 15:39:36', 3),
(167, 80, 'stage_change', 4, 4, NULL, '2024-10-23 15:39:38', 3),
(168, 49, 'stage_change', 2, 4, NULL, '2024-10-23 15:39:40', 3),
(169, 50, 'stage_change', 2, 4, NULL, '2024-10-23 15:39:41', 3),
(170, 51, 'stage_change', 2, 4, NULL, '2024-10-23 15:39:42', 3),
(171, 52, 'stage_change', 3, 4, NULL, '2024-10-23 15:39:43', 3),
(172, 53, 'stage_change', 2, 4, NULL, '2024-10-23 15:39:44', 3),
(173, 54, 'stage_change', 2, 4, NULL, '2024-10-23 15:39:44', 3),
(174, 55, 'stage_change', 3, 4, NULL, '2024-10-23 15:39:45', 3),
(175, 56, 'stage_change', 2, 4, NULL, '2024-10-23 15:39:46', 3),
(176, 57, 'stage_change', 2, 4, NULL, '2024-10-23 15:39:47', 3),
(177, 58, 'stage_change', 3, 4, NULL, '2024-10-23 15:39:48', 3),
(178, 82, 'stage_change', 4, 4, NULL, '2024-10-23 15:42:49', 3),
(179, 79, 'stage_change', 4, 4, NULL, '2024-10-23 15:42:53', 3),
(180, 83, 'stage_change', 4, 4, NULL, '2024-10-23 15:43:01', 3),
(181, 82, 'stage_change', 1, 4, NULL, '2024-10-23 15:43:04', 3),
(182, 82, 'stage_change', 1, 4, NULL, '2024-10-23 15:43:05', 3),
(183, 59, 'stage_change', 2, 4, NULL, '2024-10-23 15:43:13', 3),
(184, 60, 'stage_change', 2, 4, NULL, '2024-10-23 15:43:13', 3),
(185, 62, 'stage_change', 4, 4, NULL, '2024-10-23 15:43:17', 3),
(186, 61, 'stage_change', 3, 4, NULL, '2024-10-23 15:43:19', 3),
(187, 63, 'stage_change', 3, 4, NULL, '2024-10-23 15:43:20', 3),
(188, 64, 'stage_change', 3, 4, NULL, '2024-10-23 15:43:21', 3),
(189, 65, 'stage_change', 2, 4, NULL, '2024-10-23 15:43:22', 3),
(190, 66, 'stage_change', 2, 4, NULL, '2024-10-23 15:43:23', 3),
(191, 67, 'stage_change', 2, 4, NULL, '2024-10-23 15:43:24', 3),
(192, 68, 'stage_change', 2, 4, NULL, '2024-10-23 15:43:25', 3),
(193, 69, 'stage_change', 2, 4, NULL, '2024-10-23 15:43:26', 3),
(194, 42, 'stage_change', 2, 4, NULL, '2024-10-23 15:43:27', 3),
(195, 43, 'stage_change', 2, 4, NULL, '2024-10-23 15:43:28', 3),
(196, 44, 'stage_change', 3, 4, NULL, '2024-10-23 15:43:29', 3),
(197, 45, 'stage_change', 3, 4, NULL, '2024-10-23 15:43:31', 3),
(198, 46, 'stage_change', 2, 4, NULL, '2024-10-23 15:43:33', 3),
(199, 47, 'stage_change', 2, 4, NULL, '2024-10-23 15:43:43', 3),
(200, 48, 'stage_change', 2, 4, NULL, '2024-10-23 15:43:44', 3),
(201, 37, 'stage_change', 2, 4, NULL, '2024-10-23 15:43:44', 3),
(202, 38, 'stage_change', 2, 4, NULL, '2024-10-23 15:43:45', 3),
(203, 39, 'stage_change', 2, 4, NULL, '2024-10-23 15:43:46', 3),
(204, 40, 'stage_change', 2, 4, NULL, '2024-10-23 15:43:46', 3),
(205, 41, 'stage_change', 2, 4, NULL, '2024-10-23 15:43:47', 3),
(206, 36, 'stage_change', 2, 4, NULL, '2024-10-23 15:43:48', 3),
(207, 20, 'stage_change', 2, 4, NULL, '2024-10-23 15:43:48', 3),
(208, 23, 'stage_change', 5, 4, NULL, '2024-10-23 15:43:52', 3),
(209, 22, 'stage_change', 5, 4, NULL, '2024-10-23 15:43:54', 3),
(210, 25, 'stage_change', 1, 4, NULL, '2024-10-23 15:43:56', 3),
(211, 24, 'stage_change', 5, 4, NULL, '2024-10-23 15:44:01', 3),
(212, 22, 'stage_change', 2, 4, NULL, '2024-10-23 15:44:05', 3),
(213, 23, 'stage_change', 2, 4, NULL, '2024-10-23 15:44:06', 3),
(214, 24, 'stage_change', 2, 4, NULL, '2024-10-23 15:44:07', 3),
(215, 21, 'stage_change', 2, 4, NULL, '2024-10-23 15:44:13', 3),
(216, 25, 'stage_change', 2, 4, NULL, '2024-10-23 15:44:14', 3),
(217, 70, 'stage_change', 1, 4, NULL, '2024-10-23 15:44:17', 3),
(218, 824, 'stage_change', 2, 4, NULL, '2024-10-27 09:13:55', 8),
(219, 824, 'stage_change', 1, 4, NULL, '2024-10-27 09:13:57', 8),
(220, 853, 'stage_change', 2, 4, NULL, '2024-10-28 07:20:22', 8),
(221, 853, 'stage_change', 1, 4, NULL, '2024-10-28 07:20:28', 8),
(222, 839, 'stage_change', 2, 4, NULL, '2024-10-28 10:21:56', 8),
(223, 841, 'stage_change', 5, 4, NULL, '2024-10-28 11:41:12', 8),
(224, 840, 'stage_change', 2, 4, NULL, '2024-10-29 15:30:40', 4),
(225, 823, 'stage_change', 2, 4, NULL, '2024-10-29 15:30:46', 4),
(226, 840, 'stage_change', 2, 4, NULL, '2024-10-29 15:30:48', 4),
(227, 840, 'stage_change', 3, 4, NULL, '2024-10-29 15:30:49', 4),
(228, 774, 'stage_change', 2, 4, NULL, '2024-10-30 11:54:12', 8),
(229, 888, 'stage_change', 7, 4, NULL, '2024-10-30 16:48:47', 8),
(230, 888, 'stage_change', 1, 4, NULL, '2024-10-30 16:48:49', 8),
(231, 884, NULL, 7, 8, NULL, '2024-10-30 17:02:20', 0),
(232, 884, NULL, 7, 8, 'Correo de recontacto enviado al lead', '2024-10-30 17:02:20', 0),
(233, 884, NULL, 7, 8, 'Notificación enviada al agente', '2024-10-30 17:02:20', 0),
(234, 874, NULL, 7, 8, NULL, '2024-10-30 17:02:36', 0),
(235, 874, NULL, 7, 8, 'Correo de recontacto enviado al lead', '2024-10-30 17:02:36', 0),
(236, 874, NULL, 7, 8, 'Notificación enviada al agente', '2024-10-30 17:02:36', 0),
(237, 867, NULL, 7, 8, NULL, '2024-10-30 17:02:40', 0),
(238, 867, NULL, 7, 8, 'Correo de recontacto enviado al lead', '2024-10-30 17:02:40', 0),
(239, 867, NULL, 7, 8, 'Notificación enviada al agente', '2024-10-30 17:02:40', 0),
(240, 881, NULL, 4, 8, NULL, '2024-10-30 17:02:43', 0),
(241, 881, NULL, 7, NULL, NULL, '2024-10-30 17:03:35', 0),
(242, 624, NULL, 7, NULL, NULL, '2024-10-30 17:03:48', 0),
(243, 776, NULL, 7, NULL, NULL, '2024-10-30 17:03:58', 0),
(244, 774, NULL, 7, NULL, NULL, '2024-10-30 17:04:08', 0),
(245, 881, NULL, 6, NULL, NULL, '2024-10-30 17:05:22', 0),
(246, 881, NULL, 7, NULL, NULL, '2024-10-30 17:05:23', 0),
(247, 884, NULL, 2, NULL, NULL, '2024-10-30 17:06:29', 0),
(248, 874, NULL, 2, NULL, NULL, '2024-10-30 17:06:49', 0),
(249, 867, NULL, 2, NULL, NULL, '2024-10-30 17:06:52', 0),
(250, 774, NULL, 2, NULL, NULL, '2024-10-30 17:06:56', 0),
(251, 776, NULL, 2, NULL, NULL, '2024-10-30 17:06:59', 0),
(252, 624, NULL, 2, NULL, NULL, '2024-10-30 17:07:02', 0),
(253, 881, NULL, 6, NULL, NULL, '2024-10-30 17:07:50', 0),
(254, 881, NULL, 7, NULL, NULL, '2024-10-30 17:08:08', 0),
(255, 881, NULL, 6, NULL, NULL, '2024-10-30 17:14:57', 0),
(256, 881, NULL, 7, NULL, NULL, '2024-10-30 17:15:00', 0),
(257, 881, NULL, 6, NULL, NULL, '2024-10-30 17:16:48', 0),
(258, 881, NULL, 7, NULL, NULL, '2024-10-30 17:16:50', 0),
(259, 881, NULL, 6, NULL, NULL, '2024-10-30 17:18:11', 0),
(260, 881, NULL, 7, NULL, NULL, '2024-10-30 17:18:47', 0),
(261, 881, NULL, 6, NULL, NULL, '2024-10-30 17:22:37', 0),
(262, 881, NULL, 7, NULL, NULL, '2024-10-30 17:22:39', 0),
(263, 881, NULL, 6, NULL, NULL, '2024-10-30 17:24:30', 0),
(264, 881, NULL, 7, NULL, NULL, '2024-10-30 17:24:32', 0),
(265, 881, NULL, 6, NULL, NULL, '2024-10-30 17:24:33', 0),
(266, 881, NULL, 7, NULL, NULL, '2024-10-30 17:24:39', 0),
(267, 881, NULL, 6, NULL, NULL, '2024-10-30 17:27:55', 0),
(268, 881, NULL, 7, NULL, NULL, '2024-10-30 17:28:03', 0),
(269, 881, NULL, 6, NULL, NULL, '2024-10-30 17:28:54', 0),
(270, 881, NULL, 7, NULL, NULL, '2024-10-30 17:28:56', 0),
(271, 889, NULL, 1, NULL, NULL, '2024-10-30 17:30:51', 0),
(272, 889, NULL, 7, NULL, NULL, '2024-10-30 17:31:04', 0),
(273, 889, NULL, 6, NULL, NULL, '2024-10-30 17:35:29', 0),
(274, 889, NULL, 7, NULL, NULL, '2024-10-30 17:35:31', 0),
(275, 890, NULL, 1, NULL, NULL, '2024-10-30 17:35:46', 0),
(276, 890, NULL, 7, NULL, NULL, '2024-10-30 17:38:56', 0),
(277, 890, NULL, 6, NULL, NULL, '2024-10-30 17:40:15', 0),
(278, 890, NULL, 1, NULL, NULL, '2024-10-30 17:40:17', 0),
(279, 891, NULL, 1, NULL, NULL, '2024-10-30 17:40:27', 0),
(280, 891, NULL, 2, NULL, NULL, '2024-10-30 17:41:25', 0),
(281, 891, NULL, 3, NULL, NULL, '2024-10-30 17:44:46', 0),
(282, 892, NULL, 1, NULL, NULL, '2024-10-30 17:44:59', 0),
(283, 892, NULL, 7, NULL, NULL, '2024-10-30 17:46:26', 0),
(284, 890, NULL, 7, NULL, NULL, '2024-10-30 17:46:28', 0),
(285, 892, NULL, 5, NULL, NULL, '2024-10-30 17:46:34', 0),
(286, 890, NULL, 6, NULL, NULL, '2024-10-30 17:48:15', 0),
(287, 893, NULL, 1, NULL, NULL, '2024-10-30 17:48:28', 0),
(288, 894, NULL, 7, NULL, NULL, '2024-10-30 17:50:14', 0),
(289, 901, NULL, 1, NULL, NULL, '2024-10-31 08:19:02', 0),
(290, 901, NULL, 2, NULL, NULL, '2024-10-31 08:19:05', 0),
(291, 901, NULL, 3, NULL, NULL, '2024-10-31 08:19:07', 0),
(292, 901, NULL, 4, NULL, NULL, '2024-10-31 08:19:09', 0),
(293, 901, NULL, 6, NULL, NULL, '2024-10-31 08:19:12', 0),
(294, 902, NULL, 1, NULL, NULL, '2024-10-31 08:33:40', 0),
(295, 901, NULL, 6, NULL, NULL, '2024-10-31 08:34:00', 0),
(296, 903, NULL, 1, NULL, NULL, '2024-10-31 10:15:43', 0),
(297, 986, NULL, 1, NULL, NULL, '2024-11-04 15:27:01', 0),
(298, 71, NULL, 1, NULL, NULL, '2024-11-06 10:54:18', 3),
(299, 73, NULL, 1, NULL, NULL, '2024-11-06 10:54:19', 3),
(300, 74, NULL, 1, NULL, NULL, '2024-11-06 10:54:20', 3),
(301, 75, NULL, 1, NULL, NULL, '2024-11-06 10:54:23', 3),
(302, 76, NULL, 1, NULL, NULL, '2024-11-06 10:54:24', 3),
(303, 49, NULL, 1, NULL, NULL, '2024-11-06 10:54:25', 3),
(304, 50, NULL, 1, NULL, NULL, '2024-11-06 10:54:26', 3),
(305, 1022, NULL, 1, NULL, NULL, '2024-11-06 10:54:26', 3),
(306, 51, NULL, 1, NULL, NULL, '2024-11-06 10:54:27', 3),
(307, 53, NULL, 2, NULL, NULL, '2024-11-06 10:54:28', 3),
(308, 53, NULL, 2, NULL, NULL, '2024-11-06 10:54:28', 3),
(309, 1024, NULL, 1, NULL, NULL, '2024-11-06 13:30:24', 0),
(310, 1023, NULL, 1, NULL, NULL, '2024-11-06 13:30:30', 0),
(311, 1024, NULL, 1, NULL, NULL, '2024-11-06 13:30:31', 0),
(312, 1024, NULL, 1, NULL, NULL, '2024-11-06 13:30:33', 0),
(313, 1023, NULL, 1, NULL, NULL, '2024-11-06 13:30:34', 0),
(314, 1023, NULL, 1, NULL, NULL, '2024-11-06 13:30:54', 0),
(315, 1024, NULL, 1, NULL, NULL, '2024-11-06 13:30:55', 0),
(316, 1018, NULL, 1, NULL, NULL, '2024-11-06 13:32:36', 0),
(317, 1017, NULL, 1, NULL, NULL, '2024-11-06 13:32:38', 0),
(318, 1017, NULL, 1, NULL, NULL, '2024-11-06 13:33:35', 0),
(319, 1012, NULL, 1, NULL, NULL, '2024-11-06 13:41:52', 0),
(320, 1013, NULL, 1, NULL, NULL, '2024-11-06 13:44:54', 0),
(321, 1012, NULL, 1, NULL, NULL, '2024-11-06 13:44:55', 0),
(322, 1023, NULL, 1, NULL, NULL, '2024-11-06 13:46:42', 0),
(323, 1016, NULL, 1, NULL, NULL, '2024-11-06 13:47:16', 0),
(324, 1023, NULL, 1, NULL, NULL, '2024-11-06 13:47:47', 0),
(325, 903, NULL, 7, NULL, NULL, '2024-11-06 15:28:42', 0),
(326, 1028, NULL, 1, NULL, NULL, '2024-11-06 15:28:58', 0),
(327, 1028, NULL, 7, NULL, NULL, '2024-11-06 15:29:00', 0),
(328, 1029, NULL, 1, NULL, NULL, '2024-11-06 15:29:11', 0),
(329, 1029, NULL, 7, NULL, NULL, '2024-11-06 15:29:17', 0),
(330, 1015, NULL, 7, NULL, NULL, '2024-11-06 16:27:29', 0),
(331, 1011, NULL, 7, NULL, NULL, '2024-11-06 16:34:25', 0),
(332, 1024, NULL, 5, NULL, NULL, '2024-11-06 17:07:40', 0),
(333, 1031, NULL, 1, NULL, NULL, '2024-11-07 06:47:16', 0),
(334, 1031, NULL, 7, NULL, NULL, '2024-11-07 06:47:23', 0),
(335, 1031, NULL, 6, NULL, NULL, '2024-11-07 06:48:02', 0),
(336, 1031, NULL, 7, NULL, NULL, '2024-11-07 06:54:52', 0),
(337, 1031, NULL, 6, NULL, NULL, '2024-11-07 06:59:47', 0),
(338, 1031, NULL, 7, NULL, NULL, '2024-11-07 06:59:49', 0),
(339, 1032, NULL, 1, NULL, NULL, '2024-11-07 07:22:10', 0),
(340, 1032, NULL, 7, NULL, NULL, '2024-11-07 07:22:16', 0),
(341, 1031, NULL, 6, NULL, NULL, '2024-11-07 08:46:36', 0),
(342, 1031, NULL, 7, NULL, NULL, '2024-11-07 08:46:38', 0),
(343, 1027, NULL, 1, NULL, NULL, '2024-11-07 08:54:47', 0),
(344, 1031, NULL, 2, NULL, NULL, '2024-11-07 09:03:19', 0),
(345, 1034, NULL, 1, NULL, NULL, '2024-11-08 12:48:00', 0),
(346, 1035, NULL, 1, NULL, NULL, '2024-11-08 13:04:11', 0),
(347, 1036, NULL, 1, NULL, NULL, '2024-11-08 14:23:58', 0),
(348, 1036, NULL, 2, NULL, NULL, '2024-11-08 14:24:01', 0),
(349, 1035, NULL, 2, NULL, NULL, '2024-11-08 14:24:02', 0),
(350, 1034, NULL, 2, NULL, NULL, '2024-11-08 14:24:03', 0),
(351, 1036, NULL, 3, NULL, NULL, '2024-11-08 14:30:21', 0),
(352, 1037, NULL, 1, NULL, NULL, '2024-11-08 14:48:32', 0),
(353, 1038, NULL, 1, NULL, NULL, '2024-11-08 16:44:06', 0),
(354, 1039, NULL, 1, NULL, NULL, '2024-11-08 17:07:17', 0),
(355, 1042, NULL, 1, NULL, NULL, '2024-11-12 09:47:08', 0),
(356, 1042, NULL, 2, NULL, NULL, '2024-11-12 09:47:12', 0),
(357, 1043, NULL, 1, NULL, NULL, '2024-11-12 09:48:22', 0),
(358, 1043, NULL, 2, NULL, NULL, '2024-11-12 09:48:24', 0),
(359, 1044, NULL, 1, NULL, NULL, '2024-11-12 09:55:37', 0),
(360, 1044, NULL, 2, NULL, NULL, '2024-11-12 09:55:41', 0),
(361, 1045, NULL, 1, NULL, NULL, '2024-11-12 11:12:15', 0),
(362, 1045, NULL, 3, NULL, NULL, '2024-11-12 11:12:18', 0),
(363, 1043, NULL, 3, NULL, NULL, '2024-11-12 16:30:29', 0),
(364, 1045, NULL, 4, NULL, NULL, '2024-11-12 16:33:30', 0),
(365, 1045, NULL, 3, NULL, NULL, '2024-11-12 16:33:31', 0),
(366, 1045, NULL, 4, NULL, NULL, '2024-11-12 16:53:19', 0),
(367, 1045, NULL, 3, NULL, NULL, '2024-11-12 16:53:20', 0),
(368, 1044, NULL, 2, NULL, NULL, '2024-11-13 10:29:19', 0),
(369, 1046, NULL, 1, NULL, NULL, '2024-11-13 11:28:02', 0),
(370, 1046, NULL, 3, NULL, NULL, '2024-11-13 11:28:11', 0),
(371, 1047, NULL, 1, NULL, NULL, '2024-11-13 13:10:16', 0),
(372, 1047, NULL, 3, NULL, NULL, '2024-11-13 13:10:19', 0),
(373, 1048, NULL, 1, NULL, NULL, '2024-11-13 13:19:27', 0),
(374, 1048, NULL, 3, NULL, NULL, '2024-11-13 13:19:29', 0),
(375, 1049, NULL, 1, NULL, NULL, '2024-11-13 13:22:18', 0),
(376, 1049, NULL, 3, NULL, NULL, '2024-11-13 13:22:22', 0),
(377, 1050, NULL, 1, NULL, NULL, '2024-11-14 10:59:58', 0),
(378, 1050, NULL, 3, NULL, NULL, '2024-11-14 11:00:00', 0),
(379, 638, NULL, 3, NULL, NULL, '2024-11-14 12:18:50', 0),
(380, 638, NULL, 5, NULL, NULL, '2024-11-14 12:19:18', 0),
(381, 728, NULL, 5, NULL, NULL, '2024-11-14 12:29:36', 0),
(382, 661, NULL, 4, NULL, NULL, '2024-11-14 16:17:10', 0),
(383, 661, NULL, 2, NULL, NULL, '2024-11-14 16:17:12', 0),
(384, 798, NULL, 2, NULL, NULL, '2024-11-14 17:13:45', 0),
(385, 775, NULL, 5, NULL, NULL, '2024-11-14 18:07:34', 0),
(386, 677, NULL, 2, NULL, NULL, '2024-11-15 15:49:05', 0),
(387, 1065, NULL, 2, NULL, NULL, '2024-11-18 16:11:41', 0),
(388, 1064, NULL, 2, NULL, NULL, '2024-11-18 16:11:48', 0),
(389, 1102, NULL, 1, NULL, NULL, '2024-11-25 17:13:49', 0),
(390, 1102, NULL, 3, NULL, NULL, '2024-11-25 17:13:56', 0),
(391, 1064, NULL, 3, NULL, NULL, '2024-11-25 17:14:03', 0),
(392, 1103, NULL, 1, NULL, NULL, '2024-11-25 17:33:19', 0),
(393, 1104, NULL, 1, NULL, NULL, '2024-11-25 18:07:29', 0),
(394, 1105, NULL, 1, NULL, NULL, '2024-11-25 18:19:41', 0),
(395, 1106, NULL, 1, NULL, NULL, '2024-11-25 18:56:50', 0),
(396, 1112, NULL, 2, NULL, NULL, '2024-11-26 13:58:59', 0),
(0, 0, NULL, 2, NULL, NULL, '2025-01-13 18:48:43', 0),
(0, 0, NULL, 3, NULL, NULL, '2025-01-13 18:47:23', 0),
(0, 0, NULL, 2, NULL, NULL, '2025-01-13 18:46:38', 0),
(0, 0, NULL, 3, NULL, NULL, '2025-01-13 18:46:12', 0),
(0, 0, NULL, 2, NULL, NULL, '2025-01-13 18:42:05', 0),
(0, 0, NULL, 3, NULL, NULL, '2025-01-13 18:42:00', 0),
(0, 0, NULL, 1, NULL, NULL, '2025-01-13 18:36:06', 0),
(0, 0, NULL, 4, NULL, NULL, '2025-01-13 18:35:55', 0),
(0, 0, NULL, 2, NULL, NULL, '2025-01-13 18:35:54', 0),
(0, 0, NULL, 1, NULL, NULL, '2025-01-13 18:34:43', 0),
(0, 0, NULL, 2, NULL, NULL, '2025-01-13 18:34:41', 0),
(0, 0, NULL, 1, NULL, NULL, '2025-01-13 18:33:12', 0),
(0, 0, NULL, 3, NULL, NULL, '2025-01-13 18:32:36', 0),
(0, 0, NULL, 2, NULL, NULL, '2025-01-13 18:32:03', 0),
(0, 0, NULL, 7, NULL, NULL, '2025-01-13 18:32:00', 0),
(0, 0, NULL, 1, NULL, NULL, '2025-01-13 18:31:52', 0),
(0, 0, NULL, 2, NULL, NULL, '2025-01-13 18:31:49', 0),
(0, 0, NULL, 1, NULL, NULL, '2025-01-13 18:31:45', 0),
(0, 0, NULL, 3, NULL, NULL, '2025-01-13 18:49:42', 0),
(0, 0, NULL, 2, NULL, NULL, '2025-01-13 18:50:14', 0),
(0, 0, NULL, 1, NULL, NULL, '2025-01-13 18:50:16', 0),
(0, 0, NULL, 2, NULL, NULL, '2025-01-13 18:52:21', 0),
(0, 0, NULL, 3, NULL, NULL, '2025-01-13 18:53:40', 0),
(0, 0, NULL, 1, NULL, NULL, '2025-01-13 18:53:42', 0),
(0, 0, NULL, 2, NULL, NULL, '2025-01-13 18:54:08', 0),
(0, 0, NULL, 1, NULL, NULL, '2025-01-13 19:10:35', 0),
(0, 0, NULL, 1, NULL, NULL, '2025-01-13 19:10:37', 0),
(0, 0, NULL, 1, NULL, NULL, '2025-01-13 19:10:40', 0),
(0, 0, NULL, 1, NULL, NULL, '2025-01-13 19:10:44', 0),
(0, 0, NULL, 1, NULL, NULL, '2025-01-13 19:10:53', 0),
(0, 0, NULL, 1, NULL, NULL, '2025-01-13 19:10:55', 0),
(0, 0, NULL, 1, NULL, NULL, '2025-01-13 20:17:20', 0),
(0, 0, NULL, 1, NULL, NULL, '2025-01-13 20:17:26', 0),
(0, 0, NULL, 2, NULL, NULL, '2025-01-13 20:17:27', 0),
(0, 0, NULL, 2, NULL, NULL, '2025-01-14 08:22:45', 0),
(0, 0, NULL, 2, NULL, NULL, '2025-01-14 08:22:47', 0),
(0, 0, NULL, 4, NULL, NULL, '2025-01-14 08:22:51', 0),
(0, 0, NULL, 1, NULL, NULL, '2025-01-14 08:23:41', 0),
(0, 0, NULL, 2, NULL, NULL, '2025-01-14 08:24:07', 0),
(0, 0, NULL, 1, NULL, NULL, '2025-01-14 08:26:07', 0),
(0, 0, NULL, 2, NULL, NULL, '2025-01-14 08:35:50', 0),
(0, 0, NULL, 1, NULL, NULL, '2025-01-14 08:41:03', 0),
(0, 1, NULL, 2, NULL, NULL, '2025-01-14 08:51:50', 0),
(0, 2, NULL, 3, NULL, NULL, '2025-01-14 08:51:56', 0),
(0, 1, NULL, 1, NULL, NULL, '2025-01-14 08:52:00', 0),
(0, 91, NULL, 2, NULL, NULL, '2025-01-14 08:54:05', 0),
(0, 91, NULL, 1, NULL, NULL, '2025-01-14 08:54:07', 0),
(0, 118, NULL, 1, NULL, NULL, '2025-01-14 08:58:41', 0),
(0, 118, NULL, 2, NULL, NULL, '2025-01-14 09:10:38', 0),
(0, 119, NULL, 1, NULL, NULL, '2025-01-14 09:11:06', 0),
(0, 119, NULL, 4, NULL, NULL, '2025-01-14 09:11:08', 0),
(0, 119, NULL, 5, NULL, NULL, '2025-01-14 09:13:07', 0),
(0, 119, NULL, 6, NULL, NULL, '2025-01-14 09:13:10', 0),
(0, 119, NULL, 5, NULL, NULL, '2025-01-14 09:14:28', 0),
(0, 119, NULL, 6, NULL, NULL, '2025-01-14 09:14:31', 0),
(0, 118, NULL, 6, NULL, NULL, '2025-01-14 09:14:36', 0),
(0, 119, NULL, 5, NULL, NULL, '2025-01-14 09:15:32', 0),
(0, 118, NULL, 6, NULL, NULL, '2025-01-14 09:15:36', 0),
(0, 118, NULL, 4, NULL, NULL, '2025-01-14 09:15:39', 0),
(0, 118, NULL, 4, NULL, NULL, '2025-01-14 09:15:45', 0),
(0, 118, NULL, 6, NULL, NULL, '2025-01-14 09:15:50', 0),
(0, 119, NULL, 6, NULL, NULL, '2025-01-14 09:15:52', 0),
(0, 120, NULL, 1, NULL, NULL, '2025-01-14 09:16:06', 0),
(0, 120, NULL, 1, NULL, NULL, '2025-01-14 09:16:09', 0),
(0, 120, NULL, 1, NULL, NULL, '2025-01-14 09:16:13', 0),
(0, 120, NULL, 6, NULL, NULL, '2025-01-14 09:16:17', 0),
(0, 118, NULL, 6, NULL, NULL, '2025-01-14 09:16:26', 0),
(0, 119, NULL, 1, NULL, NULL, '2025-01-14 09:16:29', 0),
(0, 118, NULL, 1, NULL, NULL, '2025-01-14 09:16:35', 0),
(0, 118, NULL, 1, NULL, NULL, '2025-01-14 11:16:25', 0),
(0, 118, NULL, 1, NULL, NULL, '2025-01-14 11:16:27', 0),
(0, 118, NULL, 1, NULL, NULL, '2025-01-14 11:16:28', 0),
(0, 119, NULL, 1, NULL, NULL, '2025-01-14 11:16:28', 0),
(0, 108, NULL, 1, NULL, NULL, '2025-01-14 11:16:33', 0),
(0, 109, NULL, 1, NULL, NULL, '2025-01-14 11:16:34', 0),
(0, 108, NULL, 1, NULL, NULL, '2025-01-14 11:16:35', 0),
(0, 124, NULL, 1, NULL, NULL, '2025-01-14 12:40:13', 0),
(0, 119, NULL, 4, NULL, NULL, '2025-01-14 12:40:17', 0),
(0, 119, NULL, 5, NULL, NULL, '2025-01-14 12:47:28', 0),
(0, 124, NULL, 1, NULL, NULL, '2025-01-14 12:53:38', 0),
(0, 124, NULL, 2, NULL, NULL, '2025-01-14 12:53:41', 0),
(0, 117, NULL, 2, NULL, NULL, '2025-01-14 13:01:18', 0),
(0, 116, NULL, 1, NULL, NULL, '2025-01-14 13:03:15', 0),
(0, 116, NULL, 1, NULL, NULL, '2025-01-14 13:03:22', 0),
(0, 116, NULL, 2, NULL, NULL, '2025-01-14 13:03:30', 0),
(0, 107, NULL, 2, NULL, NULL, '2025-01-14 13:03:57', 0),
(0, 108, NULL, 2, NULL, NULL, '2025-01-14 13:04:23', 0),
(0, 109, NULL, 2, NULL, NULL, '2025-01-14 13:04:44', 0),
(0, 110, NULL, 2, NULL, NULL, '2025-01-14 13:05:23', 0),
(0, 111, NULL, 1, NULL, NULL, '2025-01-14 13:18:27', 0),
(0, 111, NULL, 2, NULL, NULL, '2025-01-14 13:18:35', 0),
(0, 118, NULL, 5, NULL, NULL, '2025-01-14 13:23:13', 0),
(0, 110, NULL, 2, NULL, NULL, '2025-01-14 13:27:04', 0),
(0, 110, NULL, 5, NULL, NULL, '2025-01-14 13:27:24', 0),
(0, 74, NULL, 5, NULL, NULL, '2025-01-14 13:30:27', 0),
(0, 73, NULL, 1, NULL, NULL, '2025-01-14 13:32:05', 0),
(0, 118, NULL, 4, NULL, NULL, '2025-01-14 14:09:27', 0),
(0, 118, NULL, 4, NULL, NULL, '2025-01-14 14:09:33', 0),
(0, 118, NULL, 5, NULL, NULL, '2025-01-14 14:09:35', 0),
(0, 119, 'assignment_change', 5, 0, 'Lead reasignado de admin a JOSS', '2025-01-14 14:41:21', 0),
(0, 125, NULL, 2, NULL, NULL, '2025-01-14 14:46:26', 0),
(0, 126, NULL, 4, NULL, NULL, '2025-01-14 14:46:38', 0),
(0, 126, NULL, 2, NULL, NULL, '2025-01-14 14:46:40', 0),
(0, 127, NULL, 1, NULL, NULL, '2025-01-14 15:22:40', 0),
(0, 118, 'assignment_change', 5, 0, 'Lead reasignado de Cristina a Roger', '2025-01-14 15:24:14', 0),
(0, 127, NULL, 5, NULL, NULL, '2025-01-14 15:24:28', 0),
(0, 112, NULL, 1, NULL, NULL, '2025-01-14 15:40:08', 0),
(0, 113, NULL, 1, NULL, NULL, '2025-01-14 15:40:13', 0),
(0, 119, NULL, 4, NULL, NULL, '2025-01-14 15:41:27', 0),
(0, 127, NULL, 1, NULL, NULL, '2025-01-14 15:41:37', 0),
(0, 119, NULL, 4, NULL, NULL, '2025-01-14 15:44:58', 0),
(0, 119, NULL, 4, NULL, NULL, '2025-01-14 15:45:01', 0),
(0, 119, NULL, 4, NULL, NULL, '2025-01-14 15:45:09', 0),
(0, 119, NULL, 4, NULL, NULL, '2025-01-14 15:45:17', 0),
(0, 126, NULL, 2, NULL, NULL, '2025-01-14 18:48:34', 0),
(0, 69, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Roger', '2025-01-14 18:50:48', 0),
(0, 69, NULL, 5, NULL, NULL, '2025-01-14 18:51:14', 0),
(0, 127, NULL, 5, NULL, NULL, '2025-01-14 18:51:19', 0),
(0, 132, NULL, 1, NULL, NULL, '2025-01-14 19:02:13', 0),
(0, 132, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a JOSS', '2025-01-14 19:02:17', 0),
(0, 132, 'assignment_change', 1, 1, 'Lead reasignado de JOSS a Cristina', '2025-01-14 19:02:35', 0),
(0, 132, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a JOSS', '2025-01-14 19:03:35', 0),
(0, 76, NULL, 6, NULL, NULL, '2025-01-14 19:09:34', 0),
(0, 119, NULL, 4, NULL, NULL, '2025-01-15 13:05:38', 0),
(0, 140, NULL, 1, NULL, NULL, '2025-01-16 08:40:01', 0),
(0, 75, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-16 14:16:31', 0),
(0, 75, 'assignment_change', 1, 0, 'Lead reasignado de Eze a Eze', '2025-01-16 14:16:51', 0),
(0, 140, 'assignment_change', 1, 0, 'Lead reasignado de JOSS a Eze', '2025-01-16 15:08:43', 0),
(0, 140, 'assignment_change', 1, 0, 'Lead reasignado de Eze a JOSS', '2025-01-16 15:09:49', 0),
(0, 118, 'assignment_change', 5, 0, 'Lead reasignado de Roger a JOSS', '2025-01-16 15:16:08', 0),
(0, 142, NULL, 1, NULL, NULL, '2025-01-16 15:16:19', 0),
(0, 143, NULL, 1, NULL, NULL, '2025-01-16 15:40:20', 0),
(0, 143, 'assignment_change', 1, 1, 'Lead reasignado de JOSS a Cristina', '2025-01-16 15:40:41', 0),
(0, 143, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a JOSS', '2025-01-16 15:41:06', 0),
(0, 145, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a JOSS', '2025-01-17 07:13:07', 0),
(0, 147, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a JOSS', '2025-01-17 14:57:19', 0),
(0, 160, NULL, 1, NULL, NULL, '2025-01-18 07:17:01', 0),
(0, 251, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:35:19', 0),
(0, 250, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a LAURA', '2025-01-20 22:35:40', 0),
(0, 249, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:35:49', 0),
(0, 248, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a NOELIA', '2025-01-20 22:36:05', 0),
(0, 247, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:36:20', 0),
(0, 246, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:36:30', 0),
(0, 245, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:36:44', 0),
(0, 250, 'assignment_change', 1, 0, 'Lead reasignado de LAURA a LAURA', '2025-01-20 22:36:55', 0),
(0, 242, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:37', 0),
(0, 237, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:37', 0),
(0, 234, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:37', 0),
(0, 238, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:37', 0),
(0, 239, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:37', 0),
(0, 240, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:37', 0),
(0, 232, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:37', 0),
(0, 227, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:37', 0),
(0, 225, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:37', 0),
(0, 233, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:37', 0),
(0, 224, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:37', 0),
(0, 131, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:37', 0),
(0, 130, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:37', 0),
(0, 129, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:37', 0),
(0, 128, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:37', 0),
(0, 126, 'assignment_change', 2, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:37', 0),
(0, 125, 'assignment_change', 2, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:37', 0),
(0, 116, 'assignment_change', 2, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:37', 0),
(0, 114, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:37', 0),
(0, 115, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:37', 0),
(0, 113, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:37', 0),
(0, 112, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:37', 0),
(0, 107, 'assignment_change', 2, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:37', 0),
(0, 108, 'assignment_change', 2, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:37', 0),
(0, 109, 'assignment_change', 2, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:37', 0),
(0, 111, 'assignment_change', 2, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:37', 0),
(0, 106, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:37', 0),
(0, 103, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:37', 0),
(0, 100, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:37', 0),
(0, 101, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:37', 0),
(0, 102, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:37', 0),
(0, 99, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 98, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 97, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 96, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 95, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 93, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 94, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 92, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 90, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 77, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 87, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 79, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 88, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 3, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 4, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 5, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 7, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 11, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 12, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 8, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 14, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 15, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 16, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 18, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 19, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 20, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 21, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 22, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 23, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 25, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 26, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 27, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 30, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 31, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 28, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 32, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 33, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 35, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 40, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 37, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 36, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 43, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 39, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 46, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 47, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 49, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 50, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 51, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 52, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 62, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 63, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 65, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 70, 'assignment_change', 1, 0, 'Lead reasignado de Cristina a Eze', '2025-01-20 22:46:38', 0),
(0, 69, 'assignment_change', 5, 0, 'Lead reasignado de Roger a Eze', '2025-01-20 22:46:38', 0),
(0, 76, 'assignment_change', 6, 0, 'Lead reasignado de Administrador a Cristina', '2025-01-21 06:48:53', 0),
(0, 258, NULL, 1, NULL, NULL, '2025-01-21 09:23:36', 0),
(0, 258, NULL, 5, NULL, NULL, '2025-01-21 09:23:46', 0),
(0, 252, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a EZE', '2025-01-21 11:16:11', 0),
(0, 257, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a EZE', '2025-01-21 11:16:11', 0),
(0, 255, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a EZE', '2025-01-21 11:16:11', 0),
(0, 256, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a EZE', '2025-01-21 11:16:11', 0),
(0, 253, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a EZE', '2025-01-21 11:16:11', 0),
(0, 254, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a EZE', '2025-01-21 11:16:11', 0),
(0, 230, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a LAURA', '2025-01-21 11:17:17', 0),
(0, 229, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a LAURA', '2025-01-21 11:17:17', 0),
(0, 226, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a LAURA', '2025-01-21 11:17:17', 0),
(0, 231, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a LAURA', '2025-01-21 11:17:17', 0),
(0, 244, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a LAURA', '2025-01-21 11:17:17', 0),
(0, 223, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a LAURA', '2025-01-21 11:17:17', 0),
(0, 236, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a LAURA', '2025-01-21 11:17:17', 0),
(0, 243, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a LAURA', '2025-01-21 11:17:17', 0),
(0, 228, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a LAURA', '2025-01-21 11:17:17', 0),
(0, 235, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a LAURA', '2025-01-21 11:17:17', 0),
(0, 241, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a LAURA', '2025-01-21 11:17:17', 0),
(0, 148, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:20:48', 0),
(0, 146, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:30:07', 0),
(0, 162, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a ROGER', '2025-01-21 11:32:24', 0),
(0, 6, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:33:35', 0),
(0, 150, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a NOELIA', '2025-01-21 11:34:46', 0),
(0, 150, 'assignment_change', 1, 0, 'Lead reasignado de NOELIA a ROGER', '2025-01-21 11:35:55', 0),
(0, 149, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a NOELIA', '2025-01-21 11:36:56', 0),
(0, 151, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a NOELIA', '2025-01-21 11:37:31', 0),
(0, 144, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:10', 0),
(0, 57, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:10', 0),
(0, 55, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:10', 0),
(0, 141, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:10', 0),
(0, 104, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:10', 0),
(0, 53, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:10', 0),
(0, 58, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:10', 0),
(0, 105, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:10', 0),
(0, 117, 'assignment_change', 2, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:10', 0),
(0, 139, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:10', 0),
(0, 91, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:10', 0),
(0, 56, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:10', 0),
(0, 110, 'assignment_change', 5, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:10', 0),
(0, 145, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:10', 0),
(0, 135, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:10', 0),
(0, 138, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:10', 0),
(0, 124, 'assignment_change', 2, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:10', 0),
(0, 54, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:10', 0),
(0, 64, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:10', 0),
(0, 66, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:11', 0),
(0, 136, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:11', 0),
(0, 67, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:11', 0),
(0, 137, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:11', 0),
(0, 45, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:11', 0),
(0, 81, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:11', 0),
(0, 61, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:11', 0),
(0, 60, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:11', 0),
(0, 13, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:11', 0),
(0, 78, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:11', 0),
(0, 10, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:11', 0),
(0, 59, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:11', 0),
(0, 80, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:11', 0),
(0, 74, 'assignment_change', 5, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:11', 0),
(0, 48, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:11', 0),
(0, 73, 'assignment_change', 2, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:11', 0),
(0, 29, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:11', 0),
(0, 9, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:11', 0),
(0, 68, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:11', 0),
(0, 38, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:11', 0),
(0, 85, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:11', 0),
(0, 86, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:11', 0),
(0, 17, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:11', 0),
(0, 44, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:11', 0),
(0, 71, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:11', 0),
(0, 72, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:11', 0),
(0, 89, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:11', 0),
(0, 82, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:11', 0),
(0, 83, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:11', 0),
(0, 84, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:11', 0),
(0, 24, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:11', 0),
(0, 41, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:11', 0),
(0, 42, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:11', 0),
(0, 34, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 11:40:11', 0);
INSERT INTO `lead_history` (`id`, `lead_id`, `action_type`, `stage_id`, `created_by`, `notes`, `changed_at`, `changed_by`) VALUES
(0, 159, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a NOELIA', '2025-01-21 11:41:12', 0),
(0, 153, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a NOELIA', '2025-01-21 11:41:12', 0),
(0, 160, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a NOELIA', '2025-01-21 11:41:12', 0),
(0, 158, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a NOELIA', '2025-01-21 11:41:12', 0),
(0, 157, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a NOELIA', '2025-01-21 11:41:12', 0),
(0, 152, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a NOELIA', '2025-01-21 11:41:12', 0),
(0, 155, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a NOELIA', '2025-01-21 11:41:12', 0),
(0, 156, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a NOELIA', '2025-01-21 11:41:12', 0),
(0, 154, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a NOELIA', '2025-01-21 11:41:12', 0),
(0, 163, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a NOELIA', '2025-01-21 11:41:12', 0),
(0, 161, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a NOELIA', '2025-01-21 11:41:12', 0),
(0, 167, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a NOELIA', '2025-01-21 13:12:24', 0),
(0, 172, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a NOELIA', '2025-01-21 13:12:24', 0),
(0, 164, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a NOELIA', '2025-01-21 13:12:24', 0),
(0, 169, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a NOELIA', '2025-01-21 13:12:24', 0),
(0, 173, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a NOELIA', '2025-01-21 13:12:24', 0),
(0, 171, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a NOELIA', '2025-01-21 13:12:24', 0),
(0, 166, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a NOELIA', '2025-01-21 13:12:24', 0),
(0, 170, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a NOELIA', '2025-01-21 13:12:24', 0),
(0, 174, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a NOELIA', '2025-01-21 13:12:24', 0),
(0, 165, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a NOELIA', '2025-01-21 13:12:24', 0),
(0, 69, 'assignment_change', 5, 0, 'Lead reasignado de EZE a ROGER', '2025-01-21 13:25:34', 0),
(0, 185, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a NOELIA', '2025-01-21 13:33:25', 0),
(0, 181, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a NOELIA', '2025-01-21 13:33:25', 0),
(0, 180, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a NOELIA', '2025-01-21 13:33:25', 0),
(0, 184, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a NOELIA', '2025-01-21 13:33:25', 0),
(0, 182, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a NOELIA', '2025-01-21 13:33:25', 0),
(0, 183, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a NOELIA', '2025-01-21 13:33:25', 0),
(0, 179, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a NOELIA', '2025-01-21 13:33:25', 0),
(0, 176, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a NOELIA', '2025-01-21 13:33:25', 0),
(0, 177, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a NOELIA', '2025-01-21 13:33:25', 0),
(0, 175, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a NOELIA', '2025-01-21 13:33:25', 0),
(0, 178, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a NOELIA', '2025-01-21 13:33:25', 0),
(0, 186, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a NOELIA', '2025-01-21 13:33:25', 0),
(0, 194, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a LAURA', '2025-01-21 13:35:18', 0),
(0, 201, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a LAURA', '2025-01-21 13:35:18', 0),
(0, 199, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a LAURA', '2025-01-21 13:35:18', 0),
(0, 202, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a LAURA', '2025-01-21 13:35:18', 0),
(0, 203, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a LAURA', '2025-01-21 13:35:18', 0),
(0, 200, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a LAURA', '2025-01-21 13:35:18', 0),
(0, 187, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a LAURA', '2025-01-21 13:35:19', 0),
(0, 206, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a LAURA', '2025-01-21 13:35:19', 0),
(0, 198, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a LAURA', '2025-01-21 13:35:19', 0),
(0, 197, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a LAURA', '2025-01-21 13:35:19', 0),
(0, 190, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a LAURA', '2025-01-21 13:35:19', 0),
(0, 188, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a LAURA', '2025-01-21 13:35:19', 0),
(0, 189, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a LAURA', '2025-01-21 13:35:19', 0),
(0, 205, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a LAURA', '2025-01-21 13:35:19', 0),
(0, 204, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a LAURA', '2025-01-21 13:35:19', 0),
(0, 196, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a LAURA', '2025-01-21 13:35:19', 0),
(0, 207, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a LAURA', '2025-01-21 13:35:19', 0),
(0, 193, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a LAURA', '2025-01-21 13:35:19', 0),
(0, 195, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a LAURA', '2025-01-21 13:35:19', 0),
(0, 192, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a LAURA', '2025-01-21 13:35:19', 0),
(0, 191, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a LAURA', '2025-01-21 13:35:19', 0),
(0, 222, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a LAURA', '2025-01-21 13:37:57', 0),
(0, 221, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a LAURA', '2025-01-21 13:37:57', 0),
(0, 220, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a LAURA', '2025-01-21 13:37:57', 0),
(0, 214, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 13:40:30', 0),
(0, 219, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 13:40:30', 0),
(0, 209, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 13:40:30', 0),
(0, 210, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 13:40:30', 0),
(0, 215, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 13:40:30', 0),
(0, 216, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 13:40:30', 0),
(0, 217, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 13:40:30', 0),
(0, 208, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 13:40:30', 0),
(0, 218, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 13:40:30', 0),
(0, 211, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 13:40:30', 0),
(0, 212, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 13:40:30', 0),
(0, 213, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 13:40:30', 0),
(0, 262, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 13:41:44', 0),
(0, 259, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 13:41:44', 0),
(0, 260, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 13:41:44', 0),
(0, 264, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 13:41:44', 0),
(0, 261, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 13:41:44', 0),
(0, 263, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 13:41:44', 0),
(0, 168, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 13:43:15', 0),
(0, 258, 'assignment_change', 5, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 13:43:15', 0),
(0, 218, NULL, 1, NULL, NULL, '2025-01-21 13:44:34', 0),
(0, 265, NULL, 1, NULL, NULL, '2025-01-21 14:03:13', 0),
(0, 264, NULL, 1, NULL, NULL, '2025-01-21 14:03:50', 0),
(0, 266, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 14:12:55', 0),
(0, 209, NULL, 1, NULL, NULL, '2025-01-21 14:26:53', 0),
(0, 208, NULL, 1, NULL, NULL, '2025-01-21 14:27:32', 0),
(0, 267, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 14:38:06', 0),
(0, 265, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a JOSS', '2025-01-21 15:00:11', 0),
(0, 265, NULL, 2, NULL, NULL, '2025-01-21 15:10:16', 0),
(0, 265, NULL, 4, NULL, NULL, '2025-01-21 15:10:18', 0),
(0, 265, NULL, 2, NULL, NULL, '2025-01-21 15:10:22', 0),
(0, 274, NULL, 1, NULL, NULL, '2025-01-21 16:23:08', 0),
(0, 275, NULL, 1, NULL, NULL, '2025-01-21 16:23:26', 0),
(0, 276, NULL, 1, NULL, NULL, '2025-01-21 16:23:55', 0),
(0, 277, NULL, 1, NULL, NULL, '2025-01-21 16:26:25', 0),
(0, 278, NULL, 1, NULL, NULL, '2025-01-21 16:28:12', 0),
(0, 257, NULL, 1, NULL, NULL, '2025-01-21 18:24:26', 0),
(0, 272, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 18:53:31', 0),
(0, 285, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 18:53:31', 0),
(0, 283, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 18:53:31', 0),
(0, 287, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 18:53:31', 0),
(0, 280, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 18:53:31', 0),
(0, 268, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 18:53:31', 0),
(0, 284, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 18:53:31', 0),
(0, 273, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 18:53:31', 0),
(0, 279, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 18:53:31', 0),
(0, 282, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 18:53:31', 0),
(0, 286, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 18:53:31', 0),
(0, 281, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 18:53:31', 0),
(0, 288, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 19:36:58', 0),
(0, 294, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 22:57:48', 0),
(0, 293, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 22:57:48', 0),
(0, 291, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 22:57:48', 0),
(0, 289, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 22:57:48', 0),
(0, 290, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 22:57:48', 0),
(0, 292, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 22:57:48', 0),
(0, 298, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 22:57:48', 0),
(0, 296, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 22:57:48', 0),
(0, 297, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 22:57:48', 0),
(0, 295, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 22:57:48', 0),
(0, 299, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-21 22:58:17', 0),
(0, 250, NULL, 2, NULL, NULL, '2025-01-22 09:09:51', 0),
(0, 243, NULL, 2, NULL, NULL, '2025-01-22 09:09:59', 0),
(0, 241, NULL, 2, NULL, NULL, '2025-01-22 09:10:04', 0),
(0, 236, NULL, 2, NULL, NULL, '2025-01-22 09:10:09', 0),
(0, 231, NULL, 1, NULL, NULL, '2025-01-22 09:10:23', 0),
(0, 230, NULL, 2, NULL, NULL, '2025-01-22 09:10:30', 0),
(0, 229, NULL, 2, NULL, NULL, '2025-01-22 09:10:37', 0),
(0, 228, NULL, 2, NULL, NULL, '2025-01-22 09:10:43', 0),
(0, 226, NULL, 2, NULL, NULL, '2025-01-22 09:10:48', 0),
(0, 223, NULL, 2, NULL, NULL, '2025-01-22 09:10:53', 0),
(0, 222, NULL, 2, NULL, NULL, '2025-01-22 09:11:00', 0),
(0, 221, NULL, 2, NULL, NULL, '2025-01-22 09:11:04', 0),
(0, 220, NULL, 2, NULL, NULL, '2025-01-22 09:11:10', 0),
(0, 207, NULL, 2, NULL, NULL, '2025-01-22 09:11:14', 0),
(0, 206, NULL, 2, NULL, NULL, '2025-01-22 09:11:19', 0),
(0, 205, NULL, 2, NULL, NULL, '2025-01-22 09:11:24', 0),
(0, 204, NULL, 2, NULL, NULL, '2025-01-22 09:11:28', 0),
(0, 202, NULL, 2, NULL, NULL, '2025-01-22 09:11:39', 0),
(0, 201, NULL, 2, NULL, NULL, '2025-01-22 09:11:43', 0),
(0, 200, NULL, 2, NULL, NULL, '2025-01-22 09:11:48', 0),
(0, 199, NULL, 2, NULL, NULL, '2025-01-22 09:11:53', 0),
(0, 198, NULL, 2, NULL, NULL, '2025-01-22 09:11:58', 0),
(0, 197, NULL, 2, NULL, NULL, '2025-01-22 09:12:02', 0),
(0, 196, NULL, 2, NULL, NULL, '2025-01-22 09:12:07', 0),
(0, 195, NULL, 2, NULL, NULL, '2025-01-22 09:12:11', 0),
(0, 194, NULL, 2, NULL, NULL, '2025-01-22 09:12:16', 0),
(0, 193, NULL, 2, NULL, NULL, '2025-01-22 09:12:21', 0),
(0, 192, NULL, 2, NULL, NULL, '2025-01-22 09:12:26', 0),
(0, 191, NULL, 2, NULL, NULL, '2025-01-22 09:12:30', 0),
(0, 190, NULL, 2, NULL, NULL, '2025-01-22 09:12:34', 0),
(0, 189, NULL, 2, NULL, NULL, '2025-01-22 09:12:39', 0),
(0, 244, NULL, 2, NULL, NULL, '2025-01-22 09:12:57', 0),
(0, 189, NULL, 2, NULL, NULL, '2025-01-22 09:16:21', 0),
(0, 189, NULL, 2, NULL, NULL, '2025-01-22 09:16:30', 0),
(0, 308, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-22 12:20:13', 0),
(0, 304, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-22 12:20:13', 0),
(0, 305, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-22 12:20:13', 0),
(0, 307, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-22 12:20:13', 0),
(0, 306, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-22 12:20:13', 0),
(0, 317, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-22 12:20:13', 0),
(0, 321, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-22 12:20:13', 0),
(0, 319, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-22 12:20:13', 0),
(0, 322, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-22 12:20:13', 0),
(0, 311, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-22 12:20:13', 0),
(0, 316, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-22 12:20:13', 0),
(0, 318, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-22 12:20:13', 0),
(0, 301, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-22 12:20:13', 0),
(0, 309, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-22 12:20:13', 0),
(0, 300, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-22 12:20:13', 0),
(0, 310, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-22 12:20:13', 0),
(0, 312, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-22 12:20:14', 0),
(0, 320, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-22 12:20:14', 0),
(0, 302, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-22 12:20:14', 0),
(0, 303, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-22 12:20:14', 0),
(0, 313, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-22 12:20:14', 0),
(0, 315, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-22 12:20:14', 0),
(0, 314, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-22 12:20:14', 0),
(0, 72, NULL, 2, NULL, NULL, '2025-01-22 12:28:36', 0),
(0, 71, NULL, 2, NULL, NULL, '2025-01-22 12:28:40', 0),
(0, 68, NULL, 2, NULL, NULL, '2025-01-22 12:28:44', 0),
(0, 67, NULL, 2, NULL, NULL, '2025-01-22 12:28:47', 0),
(0, 66, NULL, 2, NULL, NULL, '2025-01-22 12:28:51', 0),
(0, 64, NULL, 2, NULL, NULL, '2025-01-22 12:28:54', 0),
(0, 61, NULL, 2, NULL, NULL, '2025-01-22 12:28:57', 0),
(0, 60, NULL, 2, NULL, NULL, '2025-01-22 12:28:59', 0),
(0, 59, NULL, 2, NULL, NULL, '2025-01-22 12:29:02', 0),
(0, 58, NULL, 2, NULL, NULL, '2025-01-22 12:29:38', 0),
(0, 57, NULL, 2, NULL, NULL, '2025-01-22 12:29:41', 0),
(0, 56, NULL, 2, NULL, NULL, '2025-01-22 12:29:42', 0),
(0, 55, NULL, 2, NULL, NULL, '2025-01-22 12:29:43', 0),
(0, 54, NULL, 2, NULL, NULL, '2025-01-22 12:29:44', 0),
(0, 53, NULL, 2, NULL, NULL, '2025-01-22 12:29:51', 0),
(0, 48, NULL, 2, NULL, NULL, '2025-01-22 12:29:52', 0),
(0, 45, NULL, 2, NULL, NULL, '2025-01-22 12:29:53', 0),
(0, 44, NULL, 2, NULL, NULL, '2025-01-22 12:29:55', 0),
(0, 42, NULL, 2, NULL, NULL, '2025-01-22 12:29:56', 0),
(0, 41, NULL, 2, NULL, NULL, '2025-01-22 12:29:56', 0),
(0, 38, NULL, 2, NULL, NULL, '2025-01-22 12:29:57', 0),
(0, 34, NULL, 2, NULL, NULL, '2025-01-22 12:29:58', 0),
(0, 29, NULL, 2, NULL, NULL, '2025-01-22 12:29:59', 0),
(0, 24, NULL, 2, NULL, NULL, '2025-01-22 12:29:59', 0),
(0, 17, NULL, 2, NULL, NULL, '2025-01-22 12:30:00', 0),
(0, 13, NULL, 2, NULL, NULL, '2025-01-22 12:30:01', 0),
(0, 10, NULL, 2, NULL, NULL, '2025-01-22 12:30:02', 0),
(0, 9, NULL, 2, NULL, NULL, '2025-01-22 12:30:02', 0),
(0, 6, NULL, 2, NULL, NULL, '2025-01-22 12:30:03', 0),
(0, 85, NULL, 2, NULL, NULL, '2025-01-22 12:30:05', 0),
(0, 84, NULL, 2, NULL, NULL, '2025-01-22 12:30:07', 0),
(0, 83, NULL, 2, NULL, NULL, '2025-01-22 12:30:33', 0),
(0, 82, NULL, 2, NULL, NULL, '2025-01-22 12:30:36', 0),
(0, 81, NULL, 2, NULL, NULL, '2025-01-22 12:30:47', 0),
(0, 80, NULL, 2, NULL, NULL, '2025-01-22 12:30:48', 0),
(0, 78, NULL, 2, NULL, NULL, '2025-01-22 12:30:49', 0),
(0, 89, NULL, 2, NULL, NULL, '2025-01-22 12:30:50', 0),
(0, 86, NULL, 2, NULL, NULL, '2025-01-22 12:30:50', 0),
(0, 91, NULL, 2, NULL, NULL, '2025-01-22 12:30:51', 0),
(0, 104, NULL, 2, NULL, NULL, '2025-01-22 12:30:53', 0),
(0, 105, NULL, 2, NULL, NULL, '2025-01-22 12:30:53', 0),
(0, 135, NULL, 2, NULL, NULL, '2025-01-22 12:30:54', 0),
(0, 136, NULL, 2, NULL, NULL, '2025-01-22 12:30:55', 0),
(0, 137, NULL, 2, NULL, NULL, '2025-01-22 12:30:56', 0),
(0, 138, NULL, 2, NULL, NULL, '2025-01-22 12:31:05', 0),
(0, 139, NULL, 2, NULL, NULL, '2025-01-22 12:31:06', 0),
(0, 295, NULL, 2, NULL, NULL, '2025-01-22 12:31:07', 0),
(0, 298, NULL, 2, NULL, NULL, '2025-01-22 12:31:08', 0),
(0, 314, NULL, 2, NULL, NULL, '2025-01-22 12:31:16', 0),
(0, 319, NULL, 2, NULL, NULL, '2025-01-22 12:31:17', 0),
(0, 324, NULL, 1, NULL, NULL, '2025-01-22 12:32:02', 0),
(0, 325, NULL, 1, NULL, NULL, '2025-01-22 12:32:06', 0),
(0, 326, NULL, 1, NULL, NULL, '2025-01-22 12:32:07', 0),
(0, 327, NULL, 1, NULL, NULL, '2025-01-22 12:32:07', 0),
(0, 328, NULL, 1, NULL, NULL, '2025-01-22 12:32:08', 0),
(0, 330, NULL, 1, NULL, NULL, '2025-01-22 14:17:36', 0),
(0, 331, NULL, 1, NULL, NULL, '2025-01-22 14:19:17', 0),
(0, 332, NULL, 1, NULL, NULL, '2025-01-22 14:21:31', 0),
(0, 329, NULL, 1, NULL, NULL, '2025-01-22 15:16:17', 0),
(0, 329, NULL, 1, NULL, NULL, '2025-01-22 15:16:20', 0),
(0, 329, NULL, 1, NULL, NULL, '2025-01-22 15:16:22', 0),
(0, 329, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a LAURA', '2025-01-22 15:18:00', 0),
(0, 333, NULL, 1, NULL, NULL, '2025-01-22 16:07:12', 0),
(0, 335, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-22 18:50:50', 0),
(0, 337, NULL, 4, NULL, NULL, '2025-01-22 18:59:06', 0),
(0, 336, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a LAURA', '2025-01-22 20:02:43', 0),
(0, 333, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a LAURA', '2025-01-22 20:02:43', 0),
(0, 334, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a LAURA', '2025-01-22 20:02:43', 0),
(0, 338, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a LAURA', '2025-01-22 20:02:43', 0),
(0, 339, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a LAURA', '2025-01-22 20:02:43', 0),
(0, 340, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a NOELIA', '2025-01-22 21:37:57', 0),
(0, 341, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-22 21:38:04', 0),
(0, 318, NULL, 1, NULL, NULL, '2025-01-22 21:49:49', 0),
(0, 296, NULL, 1, NULL, NULL, '2025-01-22 21:52:45', 0),
(0, 342, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-22 22:25:29', 0),
(0, 343, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a NOELIA', '2025-01-22 23:12:58', 0),
(0, 344, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-22 23:23:47', 0),
(0, 12, NULL, 1, NULL, NULL, '2025-01-23 00:32:05', 0),
(0, 21, NULL, 1, NULL, NULL, '2025-01-23 00:37:08', 0),
(0, 352, NULL, 1, NULL, NULL, '2025-01-23 09:29:36', 0),
(0, 347, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-23 09:56:57', 0),
(0, 351, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-23 09:56:57', 0),
(0, 349, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-23 09:56:57', 0),
(0, 348, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a EZE', '2025-01-23 09:57:49', 0),
(0, 350, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a EZE', '2025-01-23 09:57:49', 0),
(0, 345, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-23 09:58:10', 0),
(0, 346, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-23 09:58:10', 0),
(0, 329, 'assignment_change', 1, 0, 'Lead reasignado de LAURA a EZE', '2025-01-23 11:33:44', 0),
(0, 365, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a NOELIA', '2025-01-23 18:49:54', 0),
(0, 364, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a LAURA', '2025-01-23 18:50:13', 0),
(0, 360, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a EZE', '2025-01-23 18:51:03', 0),
(0, 361, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a EZE', '2025-01-23 18:51:03', 0),
(0, 362, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-23 18:52:48', 0),
(0, 358, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a EZE', '2025-01-23 18:55:50', 0),
(0, 354, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-23 18:56:11', 0),
(0, 363, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a NOELIA', '2025-01-23 18:57:03', 0),
(0, 355, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-23 18:57:32', 0),
(0, 353, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a NOELIA', '2025-01-23 19:00:44', 0),
(0, 357, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a NOELIA', '2025-01-23 19:00:44', 0),
(0, 359, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a LAURA', '2025-01-23 19:00:57', 0),
(0, 356, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a EZE', '2025-01-23 19:01:11', 0),
(0, 362, NULL, 2, NULL, NULL, '2025-01-23 20:12:52', 0),
(0, 366, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a EZE', '2025-01-23 20:13:33', 0),
(0, 387, NULL, 1, NULL, NULL, '2025-01-24 06:53:38', 0),
(0, 387, NULL, 2, NULL, NULL, '2025-01-24 06:53:53', 0),
(0, 387, NULL, 4, NULL, NULL, '2025-01-24 06:55:17', 0),
(0, 387, NULL, 6, NULL, NULL, '2025-01-24 06:55:18', 0),
(0, 387, NULL, 5, NULL, NULL, '2025-01-24 06:55:44', 0),
(0, 387, NULL, 6, NULL, NULL, '2025-01-24 06:55:46', 0),
(0, 387, NULL, 5, 1, NULL, '2025-01-24 06:58:18', 0),
(0, 387, NULL, 6, 1, NULL, '2025-01-24 06:58:21', 0),
(0, 387, NULL, 5, 1, NULL, '2025-01-24 06:59:51', 0),
(0, 387, NULL, 6, 1, NULL, '2025-01-24 06:59:53', 0),
(0, 387, NULL, 5, 1, NULL, '2025-01-24 07:00:30', 0),
(0, 387, NULL, 6, 1, NULL, '2025-01-24 07:00:32', 0),
(0, 387, NULL, 5, 1, NULL, '2025-01-24 07:03:30', 0),
(0, 387, NULL, 6, 1, NULL, '2025-01-24 07:03:32', 0),
(0, 387, NULL, 5, 1, NULL, '2025-01-24 07:04:32', 0),
(0, 387, NULL, 6, 1, NULL, '2025-01-24 07:04:34', 0),
(0, 334, 'assignment_change', 1, 0, 'Lead reasignado de LAURA a CRISTINA', '2025-01-24 07:11:12', 0),
(0, 368, 'assignment_change', 1, 0, 'Lead reasignado de ADMINISTRADOR a CRISTINA', '2025-01-24 07:11:12', 0),
(0, 334, 'assignment_change', 1, 0, 'Lead reasignado de CRISTINA a CRISTINA', '2025-01-24 07:12:42', 0),
(0, 368, 'assignment_change', 1, 0, 'Lead reasignado de CRISTINA a CRISTINA', '2025-01-24 07:12:42', 0),
(0, 353, 'assignment_change', 1, 0, 'Lead reasignado de NOELIA a CRISTINA', '2025-01-24 07:13:08', 0),
(0, 387, 'assignment_change', 6, 0, 'Lead reasignado de JOSS a CRISTINA', '2025-01-24 07:13:44', 0),
(0, 387, 'assignment_change', 6, 0, 'Lead reasignado de CRISTINA a JOSS', '2025-01-24 07:14:55', 0),
(0, 387, 'assignment_change', 6, 0, 'Lead reasignado de JOSS a CRISTINA', '2025-01-24 07:17:04', 0),
(0, 387, 'assignment_change', 6, 0, 'Lead reasignado de CRISTINA a JOSS', '2025-01-24 07:17:10', 0),
(0, 387, 'assignment_change', 6, 0, 'Lead reasignado de JOSS a CRISTINA', '2025-01-24 07:18:53', 0),
(0, 387, 'assignment_change', 6, 0, 'Lead reasignado de CRISTINA a JOSS', '2025-01-24 07:19:00', 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `lead_notes`
--

CREATE TABLE `lead_notes` (
  `id` int(11) NOT NULL,
  `lead_id` int(11) NOT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `lead_recontacts`
--

CREATE TABLE `lead_recontacts` (
  `id` int(11) NOT NULL,
  `lead_id` int(11) NOT NULL,
  `scheduled_date` datetime NOT NULL,
  `notes` text DEFAULT NULL,
  `status` enum('pending','completed','cancelled') DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_by` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `lead_stages`
--

CREATE TABLE `lead_stages` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `order_num` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `lead_stages`
--

INSERT INTO `lead_stages` (`id`, `name`, `order_num`) VALUES
(1, 'Nuevo', 1),
(2, 'Contactado', 2),
(4, 'Oportunidad', 4),
(5, 'No cualifica', 5),
(6, 'Cliente ', 6);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `lead_stages_history`
--

CREATE TABLE `lead_stages_history` (
  `id` int(11) NOT NULL,
  `lead_id` int(11) NOT NULL,
  `stage_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `message_templates`
--

CREATE TABLE `message_templates` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `type` enum('whatsapp','email','sms') NOT NULL,
  `content` text NOT NULL,
  `variables` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`variables`)),
  `is_global` tinyint(1) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `metrics`
--

CREATE TABLE `metrics` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `metric_type` enum('captacion','venta','visita') NOT NULL,
  `goal` int(11) NOT NULL,
  `current` int(11) DEFAULT 0,
  `month` int(11) NOT NULL,
  `year` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `projects`
--

CREATE TABLE `projects` (
  `id` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `target_amount` decimal(10,2) DEFAULT NULL,
  `current_amount` decimal(10,2) DEFAULT NULL,
  `expected_return` decimal(5,2) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `projects`
--

INSERT INTO `projects` (`id`, `name`, `description`, `target_amount`, `current_amount`, `expected_return`, `start_date`, `end_date`, `status`, `created_at`) VALUES
(1, 'Armani', 'Casas armani en Miami', 5000000.00, 2500000.00, 7.50, '2024-01-01', '2025-01-01', 'active', '2025-01-23 18:04:59'),
(2, 'Camping Galiza', 'Complejo residencial de lujo con vistas al mar', 1000000.00, 500000.00, 13.00, '2024-01-01', '2025-01-01', 'active', '2025-01-23 18:04:59'),
(3, 'Armani', 'Casas armani en Miami', 5000000.00, NULL, 7.50, NULL, NULL, 'active', '2025-01-23 18:24:56');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `properties`
--

CREATE TABLE `properties` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `address` varchar(255) NOT NULL,
  `property_type` enum('piso','casa','chalet','local','terreno') NOT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `size` int(11) DEFAULT NULL,
  `bedrooms` int(11) DEFAULT NULL,
  `bathrooms` int(11) DEFAULT NULL,
  `status` enum('activa','vendida','reservada','captacion') DEFAULT 'activa',
  `photo_status` enum('pendiente','completo') DEFAULT 'pendiente',
  `docs_status` enum('pendiente','completo') DEFAULT 'pendiente',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `property_documents`
--

CREATE TABLE `property_documents` (
  `id` int(11) NOT NULL,
  `property_id` int(11) NOT NULL,
  `document_type` enum('nota_simple','certificado_energetico','planos','escritura','otro') NOT NULL,
  `status` enum('pendiente','en_proceso','completado') DEFAULT 'pendiente',
  `notes` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tasks`
--

CREATE TABLE `tasks` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `property_id` int(11) DEFAULT NULL,
  `lead_id` int(11) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `task_type` enum('documentacion','seguimiento','llamada','otro') NOT NULL,
  `priority` enum('baja','media','alta') DEFAULT 'media',
  `due_date` date DEFAULT NULL,
  `status` enum('pendiente','en_proceso','completada') DEFAULT 'pendiente',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','user') DEFAULT 'user',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `facebook_page_id` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user_groups`
--

CREATE TABLE `user_groups` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `user_groups`
--

INSERT INTO `user_groups` (`id`, `name`, `created_at`) VALUES
(1, 'Grupo de Rafa - Vicus', '2024-11-12 16:33:06'),
(2, 'Grupo de Jose - CEO', '2024-11-12 16:33:06'),
(3, 'Grupo de Jaber - Vicus', '2024-11-12 16:33:06'),
(4, 'Grupo compartido 2024-11-12 17:44:15', '2024-11-12 16:44:15'),
(5, 'Grupo compartido 2024-11-12 17:45:35', '2024-11-12 16:45:35'),
(6, 'Grupo compartido 2024-11-12 17:45:36', '2024-11-12 16:45:36'),
(7, 'Grupo compartido 2024-11-12 17:45:36', '2024-11-12 16:45:36'),
(8, 'Grupo compartido 2024-11-12 17:48:07', '2024-11-12 16:48:07');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user_group_members`
--

CREATE TABLE `user_group_members` (
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  `role` varchar(50) DEFAULT 'member',
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `user_group_members`
--

INSERT INTO `user_group_members` (`user_id`, `group_id`, `role`, `created_at`) VALUES
(11, 11, 'admin', '2024-11-12 16:33:06'),
(10, 10, 'admin', '2024-11-12 16:33:06'),
(8, 8, 'admin', '2024-11-12 16:33:06'),
(11, 4, 'admin', '2024-11-12 16:44:15'),
(12, 4, 'member', '2024-11-12 16:44:15'),
(12, 5, 'admin', '2024-11-12 16:45:35'),
(11, 5, 'member', '2024-11-12 16:45:35'),
(12, 6, 'admin', '2024-11-12 16:45:36'),
(11, 6, 'member', '2024-11-12 16:45:36'),
(12, 7, 'admin', '2024-11-12 16:45:36'),
(11, 7, 'member', '2024-11-12 16:45:36'),
(11, 8, 'admin', '2024-11-12 16:48:07'),
(12, 8, 'member', '2024-11-12 16:48:07');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user_lead_permissions`
--

CREATE TABLE `user_lead_permissions` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `lead_id` int(11) NOT NULL,
  `can_view` tinyint(1) DEFAULT 1,
  `can_edit` tinyint(1) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `created_by` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `user_lead_permissions`
--

INSERT INTO `user_lead_permissions` (`id`, `user_id`, `lead_id`, `can_view`, `can_edit`, `created_at`, `created_by`) VALUES
(1, 12, 1045, 1, 1, '2024-11-12 17:02:11', 11),
(2, 12, 1043, 1, 1, '2024-11-12 17:02:15', 11),
(3, 12, 1036, 1, 1, '2024-11-12 17:02:18', 11),
(0, 1, 119, 1, 1, '2025-01-14 14:41:21', 0),
(0, 2, 118, 0, 0, '2025-01-14 15:24:14', 0),
(0, 2, 69, 1, 1, '2025-01-14 18:50:48', 0),
(0, 1, 132, 0, 0, '2025-01-14 19:02:17', 0),
(0, 0, 132, 0, 0, '2025-01-14 19:02:35', 1),
(0, 1, 132, 1, 1, '2025-01-14 19:03:35', 0),
(0, 5, 75, 0, 0, '2025-01-16 14:16:31', 0),
(0, 5, 75, 1, 1, '2025-01-16 14:16:51', 0),
(0, 5, 140, 0, 0, '2025-01-16 15:08:44', 0),
(0, 1, 140, 1, 1, '2025-01-16 15:09:49', 0),
(0, 1, 118, 1, 1, '2025-01-16 15:16:08', 0),
(0, 0, 143, 0, 0, '2025-01-16 15:40:41', 1),
(0, 1, 143, 1, 1, '2025-01-16 15:41:06', 0),
(0, 1, 145, 1, 1, '2025-01-17 07:13:07', 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user_roles`
--

CREATE TABLE `user_roles` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `user_roles`
--

INSERT INTO `user_roles` (`id`, `name`) VALUES
(1, 'admin'),
(2, 'user');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user_stats`
--

CREATE TABLE `user_stats` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `total_leads` int(11) DEFAULT 0,
  `active_leads` int(11) DEFAULT 0,
  `converted_leads` int(11) DEFAULT 0,
  `last_login` datetime DEFAULT NULL,
  `registration_date` datetime DEFAULT NULL,
  `last_activity` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `activity_log`
--

--Indices de la tabla (Aún no en la base de datos)
ALTER TABLE `activity_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indices de la tabla `appointments`
--
ALTER TABLE `appointments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `lead_id` (`lead_id`),
  ADD KEY `idx_user_date` (`user_id`,`start_time`);

--
-- Indices de la tabla `communication_history`
--
ALTER TABLE `communication_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `lead_id` (`lead_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indices de la tabla `follow_ups`
--
ALTER TABLE `follow_ups`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `lead_id` (`lead_id`);

--
-- Indices de la tabla `follow_up_tags`
--
ALTER TABLE `follow_up_tags`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indices de la tabla `investments`
--
ALTER TABLE `investments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `lead_id` (`lead_id`);

--
-- Indices de la tabla `investment_documents`
--
ALTER TABLE `investment_documents`
  ADD PRIMARY KEY (`id`),
  ADD KEY `investment_id` (`investment_id`),
  ADD KEY `uploaded_by` (`uploaded_by`);

--
-- Indices de la tabla `investment_payments`
--
ALTER TABLE `investment_payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `investment_id` (`investment_id`);

--
-- Indices de la tabla `investment_performance`
--
ALTER TABLE `investment_performance`
  ADD PRIMARY KEY (`id`),
  ADD KEY `investor_id` (`investor_id`);

--
-- Indices de la tabla `investment_updates`
--
ALTER TABLE `investment_updates`
  ADD PRIMARY KEY (`id`),
  ADD KEY `investment_id` (`investment_id`),
  ADD KEY `created_by` (`created_by`);

--
-- Indices de la tabla `investors`
--
ALTER TABLE `investors`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `project_id` (`project_id`);

--
-- Indices de la tabla `investor_documents`
--
ALTER TABLE `investor_documents`
  ADD PRIMARY KEY (`id`),
  ADD KEY `investor_id` (`investor_id`);

--
-- Indices de la tabla `investor_notifications`
--
ALTER TABLE `investor_notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `lead_id` (`lead_id`);

--
-- Indices de la tabla `leads`
--
ALTER TABLE `leads`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `stage_id` (`stage_id`),
  ADD KEY `investor_id` (`investor_id`);

--
-- Indices de la tabla `lead_notes`
--
ALTER TABLE `lead_notes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `lead_id` (`lead_id`);

--
-- Indices de la tabla `lead_stages`
--
ALTER TABLE `lead_stages`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `projects`
--
ALTER TABLE `projects`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `user_lead_permissions`
--
ALTER TABLE `user_lead_permissions`
  ADD KEY `idx_permissions_user_lead` (`user_id`,`lead_id`),
  ADD KEY `idx_permissions_lead` (`lead_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `communication_history`
--
ALTER TABLE `communication_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT de la tabla `investments`
--
ALTER TABLE `investments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `investment_documents`
--
ALTER TABLE `investment_documents`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `investment_payments`
--
ALTER TABLE `investment_payments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `investment_performance`
--
ALTER TABLE `investment_performance`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `investment_updates`
--
ALTER TABLE `investment_updates`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `investors`
--
ALTER TABLE `investors`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `investor_documents`
--
ALTER TABLE `investor_documents`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `investor_notifications`
--
ALTER TABLE `investor_notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `leads`
--
ALTER TABLE `leads`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=389;

--
-- AUTO_INCREMENT de la tabla `lead_notes`
--
ALTER TABLE `lead_notes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `lead_stages`
--
ALTER TABLE `lead_stages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `projects`
--
ALTER TABLE `projects`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
