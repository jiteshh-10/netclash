import 'package:form_field_validator/form_field_validator.dart';

final emailValidator = MultiValidator([
  RequiredValidator(errorText: 'Email is required'),
  EmailValidator(errorText: 'Enter a valid email address'),
]);

final passwordValidator = MultiValidator([
  RequiredValidator(errorText: 'Password is required'),
  MinLengthValidator(6, errorText: 'Password must be at least 6 characters long'),
]);

final displayNameValidator = MultiValidator([
  RequiredValidator(errorText: 'Display name is required'),
  MinLengthValidator(3, errorText: 'Display name must be at least 3 characters long'),
]);