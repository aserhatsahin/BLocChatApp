part of 'typing_indicator_bloc.dart';

abstract class TypingIndicatorEvent extends Equatable {
  const TypingIndicatorEvent();

  @override
  List<Object?> get props => [];
}

class SubscribeTypingIndicator extends TypingIndicatorEvent {
  final String receiverUid;

  const SubscribeTypingIndicator({required this.receiverUid});

  @override
  List<Object?> get props => [receiverUid];
}

