part of 'typing_indicator_bloc.dart';

class TypingIndicatorState extends Equatable {
  final bool isTyping;

  const TypingIndicatorState({required this.isTyping});

  @override
  List<Object?> get props => [isTyping];
}

