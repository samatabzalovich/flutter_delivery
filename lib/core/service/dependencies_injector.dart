import 'package:dio/dio.dart';
import 'package:flutter_delivery/core/constants/constants.dart';
import 'package:flutter_delivery/core/service/google_maps_helper.dart';
import 'package:flutter_delivery/core/service/location.dart';
import 'package:flutter_delivery/core/service/socket_service.dart';
import 'package:flutter_delivery/features/auth/data/data_sources/local/auth_local_service.dart';
import 'package:flutter_delivery/features/auth/data/data_sources/local/auth_local_service_impl.dart';
import 'package:flutter_delivery/features/auth/data/data_sources/remote/auth_api_service.dart';
import 'package:flutter_delivery/features/auth/data/data_sources/remote/auth_api_service_impl.dart';
import 'package:flutter_delivery/features/auth/data/repository/auth_repository_impl.dart';
import 'package:flutter_delivery/features/auth/domain/repository/auth_repository.dart';
import 'package:flutter_delivery/features/auth/domain/usecases/check_user_token.dart';
import 'package:flutter_delivery/features/auth/domain/usecases/get_token.dart';
import 'package:flutter_delivery/features/auth/domain/usecases/log_in.dart';
import 'package:flutter_delivery/features/auth/domain/usecases/log_out.dart';
import 'package:flutter_delivery/features/auth/domain/usecases/register.dart';
import 'package:flutter_delivery/features/auth/domain/usecases/set_token.dart';
import 'package:flutter_delivery/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_delivery/features/driver_app/data/data_source/emit_to_socket/socket_api.dart';
import 'package:flutter_delivery/features/driver_app/data/data_source/emit_to_socket/socket_api_impl.dart';
import 'package:flutter_delivery/features/driver_app/data/data_source/remote/google_maps_api.dart';
import 'package:flutter_delivery/features/driver_app/data/data_source/remote/google_maps_api_impl.dart';
import 'package:flutter_delivery/features/driver_app/data/data_source/stream/socket_message.dart';
import 'package:flutter_delivery/features/driver_app/data/data_source/stream/socket_error_impl.dart';
import 'package:flutter_delivery/features/driver_app/data/data_source/stream/socket_stream_api.dart';
import 'package:flutter_delivery/features/driver_app/data/data_source/stream/socket_stream_impl.dart';
import 'package:flutter_delivery/features/driver_app/data/repository/driver_repository_impl.dart';
import 'package:flutter_delivery/features/driver_app/domain/repository/driver_repository.dart';
import 'package:flutter_delivery/features/driver_app/domain/usecase/accept_order.dart';
import 'package:flutter_delivery/features/driver_app/domain/usecase/close_error_stream.dart';
import 'package:flutter_delivery/features/driver_app/domain/usecase/close_socket_stream.dart';
import 'package:flutter_delivery/features/driver_app/domain/usecase/complete_order.dart';
import 'package:flutter_delivery/features/driver_app/domain/usecase/disconnect.dart';
import 'package:flutter_delivery/features/driver_app/domain/usecase/get_polyline.dart';
import 'package:flutter_delivery/features/driver_app/domain/usecase/initalize_socket.dart';
import 'package:flutter_delivery/features/driver_app/domain/usecase/off_line.dart';
import 'package:flutter_delivery/features/driver_app/domain/usecase/on_line.dart';
import 'package:flutter_delivery/features/driver_app/domain/usecase/pick_order.dart';
import 'package:flutter_delivery/features/driver_app/domain/usecase/send_location.dart';
import 'package:flutter_delivery/features/driver_app/domain/usecase/server_message.dart';
import 'package:flutter_delivery/features/driver_app/domain/usecase/stream_order.dart';
import 'package:flutter_delivery/features/driver_app/presentation/bloc/delivery_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get_it/get_it.dart';

part 'dependency_injection.dart';
