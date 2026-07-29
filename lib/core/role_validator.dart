/// Restricts which `role` values a user can self-assign at registration.
///
/// IMPORTANT: this is client-side defense in depth only. The
/// authoritative check has to live in firestore.rules — a rule like
/// `request.resource.data.role in ['student', 'mentor']` on the
/// `users/{userId}` create rule — because a client-side check can always
/// be bypassed by talking to the Firestore API directly. Flag this to
/// whoever owns firestore.rules if it isn't there yet.
class RoleValidator {
  RoleValidator._();

  static const List<String> allowedRegistrationRoles = ['student', 'mentor'];

  static bool isValidRegistrationRole(String role) =>
      allowedRegistrationRoles.contains(role);
}
