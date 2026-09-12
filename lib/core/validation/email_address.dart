/// Checks basic address structure; the server remains authoritative for email policy.
bool hasValidEmailStructure(String value) =>
    RegExp(r'^[^\s@]+@[^\s@]+$').hasMatch(value.trim());
