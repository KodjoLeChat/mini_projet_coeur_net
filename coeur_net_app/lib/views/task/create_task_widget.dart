import 'package:coeur_net_app/models/task.dart';
import 'package:coeur_net_app/providers/task_provider.dart';
import 'package:coeur_net_app/views/task/description_text_form_field.dart';
import 'package:coeur_net_app/views/task/title_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CreateTaskWidget extends StatelessWidget {
  final Task? task;
  final bool isAdmin;
  const CreateTaskWidget({this.task, super.key, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        child: ProviderScope(
          overrides: [
            createTaskViewModel.overrideWith(
              (ref) =>
                  task ??
                  Task(description: '', title: '', status: TaskStatus.pending),
            ),
          ],
          child: _Form(isEdit: task != null, isAdmin: isAdmin),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  final bool isEdit;
  final bool isAdmin;
  const _Form({required this.isEdit, required this.isAdmin});

  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {
  final _formKey = GlobalKey<FormState>();

  String? _error;

  void _setError(String? message) {
    setState(() => _error = message);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_error != null) ...[
            Text(_error!, style: TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
          ],
          TitleTextFormField(),
          const SizedBox(height: 16),
          DescriptionTextFormField(),
          const SizedBox(height: 32),
          _SubmitButton(
            formKey: _formKey,
            onError: _setError,
            isEdit: widget.isEdit,
            isAdmin: widget.isAdmin,
          ),
        ],
      ),
    );
  }
}

class _SubmitButton extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  final void Function(String? message) onError;
  final bool isEdit;
  final bool isAdmin;
  const _SubmitButton({
    required this.formKey,
    required this.onError,
    required this.isEdit,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(taskNotifierProvider('createTask'));
    final text = isEdit ? 'Modifier' : 'Ajouter';
    final nav = Navigator.of(context);
    return Skeletonizer(
      enabled: isLoading,
      child: ElevatedButton(
        onPressed: () async {
          onError(null);
          final isValidForm = formKey.currentState?.validate();

          if (isValidForm != true) return;

          final state = ref.read(createTaskViewModel);

          try {
            if (isEdit) {
              if (isAdmin) {
                await ref
                    .read(taskNotifierProvider('createTask').notifier)
                    .adminUpdate(state);
              } else {
                await ref
                    .read(taskNotifierProvider('createTask').notifier)
                    .update(state);
              }
            } else {
              await ref
                  .read(taskNotifierProvider('createTask').notifier)
                  .create(state);
            }
            nav.pop();
          } catch (e) {
            onError('Erreur $e');
          }
        },
        child: Text(text),
      ),
    );
  }
}

class CreateTaskModalWrapper extends StatelessWidget {
  final Task? task;
  final bool isAdmin;
  const CreateTaskModalWrapper({super.key, this.task, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: SingleChildScrollView(
            controller: scrollController,
            child: CreateTaskWidget(task: task, isAdmin: isAdmin),
          ),
        );
      },
    );
  }
}
