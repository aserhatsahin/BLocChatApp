import 'dart:async';
import 'dart:developer';
import 'package:bloc_chatapp/commons/app_colors.dart';
import 'package:bloc_chatapp/commons/app_styles.dart';
import 'package:bloc_chatapp/commons/widgets/input_text_field.dart';
import 'package:bloc_chatapp/modules/chat_list_module/bloc/search_user/search_user_bloc.dart';
import 'package:bloc_chatapp/modules/chat_list_module/bloc/start_chat/start_chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final _userSearchController = TextEditingController();
  final _focusNode = FocusNode();
  Timer? _debounce;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink =
      LayerLink(); //dropdown menu ile arama kutusunu hizalamak icin gerekiyor [CompositedTransformFollower] ve [CompositedTransformTarget] widgetlarina parametre olarak _layerLink i yollayarak aralarinda baglanti kuruyoruz aslinda

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _showOverlay();
      } else {
        _hideOverlay();
      }
    });
  }

  @override
  void dispose() {
    _userSearchController.dispose();
    _focusNode.dispose();
    _debounce?.cancel();
    _hideOverlay();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      //kullanici her harf icin tek tek hemen arama yapmasin diye bi bekleme suresi koyuyoruz
      context.read<SearchUserBloc>().add(SearchUserRequested(username: query));
      _showOverlay();
    });
  }

  void _showOverlay() {
    _hideOverlay();
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  //OVERLAY -> provides a way to manage a stack of widgets that float above the main app content, without being confined to the regular widget
  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder:
          (overlayContext) => Positioned(
            width: MediaQuery.of(context).size.width - 32,

            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: const Offset(0, 60),

              child: Material(
                elevation: 1.0,
                color: Colors.grey.shade200,

                borderOnForeground: true,
                shape: RoundedRectangleBorder(),
                child: _buildDropdownContent(context), // `context` buraya geçiyor
              ),
            ),
          ),
    );
  }

  Widget _buildDropdownContent(BuildContext blocContext) {
    return BlocBuilder<SearchUserBloc, SearchUserState>(
      bloc: blocContext.read<SearchUserBloc>(), // Doğru context'ten BLoC'u al
      builder: (context, state) {
        log('Overlay state: $state');
        if (state is SearchUserLoading) {
          return Container(
            padding: const EdgeInsets.all(AppStyles.paddingSmall),
            constraints: const BoxConstraints(maxHeight: AppStyles.heightXLarge * 4),
            child: const Center(child: CircularProgressIndicator(color: AppColors.accent)),
          );
        } else if (state is SearchUserFailure) {
          return Container(
            padding: const EdgeInsets.all(AppStyles.paddingXLarge),
            constraints: const BoxConstraints(maxHeight: AppStyles.heightXLarge * 4),
            child: Text(
              'Error: ',
              style: TextStyle(fontSize: AppStyles.textMedium, color: AppColors.darkGrey),
            ),
          );
        } else if (state is SearchUserLoaded) {
          final filteredUsers =
              state.users
                  .where(
                    (user) => user.username.toLowerCase().contains(
                      _userSearchController.text.toLowerCase(),
                    ),
                  )
                  .toList();

          return Container(
            constraints: const BoxConstraints(maxHeight: AppStyles.heightXLarge * 4),
            child:
                filteredUsers.isEmpty
                    ? Container(
                      alignment: Alignment.center,
                      height: AppStyles.heightXLarge,
                      child: Padding(padding: EdgeInsets.zero, child: Text('No users found')),
                    )
                    : ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = filteredUsers[index];
                        return ListTile(
                          leading: Icon(Icons.supervised_user_circle_sharp),
                          title: Text(
                            user.username,
                            style: TextStyle(
                              fontSize: AppStyles.textMedium,
                              color: AppColors.black,
                            ),
                          ),
                          minVerticalPadding: 4,

                          tileColor: Colors.grey.shade200,
                          hoverColor: AppColors.secondary.withAlpha(50),
                          onTap: () {
                            // buraya kullanici aramadan sonra kullaniciya tikladigimizda yeni sohbet baslatma ve onu listeye ekleyip orda gosterme
                            context.read<StartChatBloc>().add(
                              StartChatRequested(receiverUid: user.uid),
                            );
                            _hideOverlay();
                            _userSearchController.clear();
                          },
                        );
                      },
                    ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: InputTextField(
        controller: _userSearchController,
        prefixIcon: Icon(Icons.search, color: AppColors.darkBackground),
        hintText: 'Search Users',
        obscureText: false,
        keyboardType: TextInputType.text,
        onChanged: (value) => _onSearchChanged(value ?? ''),
        focusNode: _focusNode,
      ),
    );
  }
}
