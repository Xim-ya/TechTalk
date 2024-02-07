import 'package:techtalk/app/di/app_binding.dart';
import 'package:techtalk/features/wrong_answer_note/data_source/remote/wrong_answer_note_remote_data_source.dart';
import 'package:techtalk/features/wrong_answer_note/repositories/wrong_answer_note_repository.dart';
import 'package:techtalk/features/wrong_answer_note/usecases/get_wrong_answer_note_use_case.dart';

export 'data_source/remote/models/wrong_answer_note_answer_model.dart';
export 'data_source/remote/models/wrong_answer_note_model.dart';
export 'data_source/remote/models/wrong_answer_note_ref.dart';
export 'data_source/remote/wrong_answer_note_remote_data_source.dart';
export 'repositories/entities/wrong_answer_note_answer_entity.dart';
export 'repositories/entities/wrong_answer_note_entity.dart';
export 'repositories/wrong_answer_note_repository.dart';
export 'usecases/get_wrong_answer_note_use_case.dart';

final wrongAnswerNoteRemoteDataSource =
    locator<WrongAnswerNoteRemoteDataSource>();
final wrongAnswerNoteRepository = locator<WrongAnswerNoteRepository>();
final getWrongAnswerNotesUseCase = locator<GetWrongAnswerNoteUseCase>();
