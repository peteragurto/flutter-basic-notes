class CloudStorageException implements Exception {
  const CloudStorageException();
}

// C in Crud
class CouldNotCreateNoteException extends CloudStorageException {}

// R in Crud
class CouldNotGetAllNotesException extends CloudStorageException {}

// U in Crud
class CouldNotUpdateNoteException extends CloudStorageException {}

// D in Crud
class CouldNotDeleteNoteException extends CloudStorageException {}
