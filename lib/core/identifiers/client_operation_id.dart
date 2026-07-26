import 'package:uuid/uuid.dart';

const _uuid = Uuid();

String newClientOperationId() => _uuid.v4();
