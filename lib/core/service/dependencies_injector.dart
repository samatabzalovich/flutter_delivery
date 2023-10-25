import 'package:dio/dio.dart';
import 'package:flutter_delivery/core/constants/constants.dart';
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
import 'package:get_it/get_it.dart';

part 'dependency_injection.dart';
