/// Preserves permission flags above bit 31 when compiled to JavaScript.
abstract final class PermissionBits {
  static bool contains(int permissions, int flag) =>
      (BigInt.from(permissions) & BigInt.from(flag)) != BigInt.zero;

  static int add(int permissions, int flags) =>
      (BigInt.from(permissions) | BigInt.from(flags)).toInt();

  static int remove(int permissions, int flags) =>
      (BigInt.from(permissions) & ~BigInt.from(flags)).toInt();
}
