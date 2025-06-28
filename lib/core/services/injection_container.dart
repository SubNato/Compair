import 'package:compair_hub/core/common/app/cache_helper.dart';
import 'package:compair_hub/src/auth/data/datasources/auth_remote_data_source.dart';
import 'package:compair_hub/src/auth/data/repositories/auth_repository_implementation.dart';
import 'package:compair_hub/src/auth/domain/repositories/auth_repository.dart';
import 'package:compair_hub/src/auth/domain/usecases/forgot_password.dart';
import 'package:compair_hub/src/auth/domain/usecases/login.dart';
import 'package:compair_hub/src/auth/domain/usecases/register.dart';
import 'package:compair_hub/src/auth/domain/usecases/reset_password.dart';
import 'package:compair_hub/src/auth/domain/usecases/verify_o_t_p.dart';
import 'package:compair_hub/src/auth/domain/usecases/verify_token.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

part 'injection_container.main.dart';
