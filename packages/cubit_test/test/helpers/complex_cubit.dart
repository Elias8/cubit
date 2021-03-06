import 'package:cubit/cubit.dart';

abstract class ComplexState {}

class ComplexStateA extends ComplexState {}

class ComplexStateB extends ComplexState {}

class ComplexCubit extends Cubit<ComplexState> {
  ComplexCubit() : super(initialState: ComplexStateA());

  void emitA() => emit(ComplexStateA());
  void emitB() => emit(ComplexStateB());
}
