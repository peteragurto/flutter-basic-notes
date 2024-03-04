// Excepciones para nuestro servicio CRUD
class DatabaseAlreadyOpenException implements Exception {}

class UnableToGetDocumentsDirectory implements Exception {}

class DatabaseNotOpenException implements Exception {}

class CouldNotDeleteUser implements Exception {}

class CouldNotDeleteNote implements Exception {}

class CouldNotFindUser implements Exception {}

class CouldNotFindNote implements Exception {}

class CouldNotUpdateNote implements Exception {}

class UserAlreadyExistsException implements Exception {}
