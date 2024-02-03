import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:login_social/blocs/create_post_bloc/create_post_bloc.dart';
import 'package:login_social/blocs/get_post_bloc/get_post_bloc.dart';
import 'package:login_social/blocs/get_post_bloc/get_post_bloc.dart';
import 'package:login_social/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:login_social/blocs/sign_bloc/sign_bloc.dart';
import 'package:login_social/blocs/update_user_info_bloc/update_user_info_bloc.dart';
import 'package:login_social/screens/home/post_screen.dart';
import 'package:post_rep/post_rep.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateUserInfoBloc, UpdateUserInfoState>(
      listener: (context, state) {
        if(state is UploadPictureSuccess){
          setState(() {
            context.read<MyUserBloc>().state.user!.picture = state.userImage;
          });
        }
      },
      child: Scaffold(
          floatingActionButton: BlocBuilder<MyUserBloc, MyUserState>(
            builder: (context, state) {
              if (state.status == MyUserStatus.success) {
                return FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                BlocProvider<CreatePostBloc>(
                                  create: (context) => CreatePostBloc(myPostRepository: FirebasePostRepository()),
                                  child: PostScreen(
                                    state.user!
                                ),
                                )));
                  },
                  child: const Icon(Icons.add, color: Colors.orange,),
                );
              }
              else{
                return const FloatingActionButton(
                  onPressed: null,
                  child: Icon(Icons.clear, color: Colors.orange,),
                );
              }
              },
),
          appBar: AppBar(
            centerTitle: false,
            backgroundColor: Theme.of(context).colorScheme.background,
            elevation: 0,
            title: BlocBuilder<MyUserBloc, MyUserState>(
            builder: (context, state) {
              if (state.status == MyUserStatus.success) {
                return Row(
                  children: [
                  state.user!.picture == ""
                      ?
                  GestureDetector(
                    onTap: () async {
                      final Color color = Theme.of(context).colorScheme.primary;
                      final ImagePicker picker = ImagePicker();
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.gallery,
                          maxHeight: 500,
                          maxWidth: 500,
                          imageQuality: 60);
                      if(image != null){
                        CroppedFile? croppedFile = await ImageCropper().cropImage(
                            sourcePath: image.path,aspectRatio:
                        const CropAspectRatio(ratioX: 1, ratioY: 1),aspectRatioPresets: [
                          CropAspectRatioPreset.square
                        ],
                        uiSettings: [
                          AndroidUiSettings(
                            toolbarTitle: 'Cropper',
                            toolbarColor: color,
                            toolbarWidgetColor:Colors.white,
                            initAspectRatio: CropAspectRatioPreset.original,
                            lockAspectRatio: false,

                          ),
                        ]);
                        if (croppedFile != null){
                          setState(() {
                            context.read<UpdateUserInfoBloc>().add(
                                UploadPicture(
                                    croppedFile.path,
                                    context.read<MyUserBloc>().state.user!.id));
                          });
                        }
                      }
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle
                      ),
                      child: const Icon(CupertinoIcons.person),
                    ),
                  ) : GestureDetector(
                    onTap: () async {
                      final Color color = Theme.of(context).colorScheme.primary;
                      final ImagePicker picker = ImagePicker();
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.gallery,
                          maxHeight: 500,
                          maxWidth: 500,
                          imageQuality: 60);
                      if(image != null){
                        CroppedFile? croppedFile = await ImageCropper().cropImage(
                            sourcePath: image.path,aspectRatio:
                        const CropAspectRatio(ratioX: 1, ratioY: 1),aspectRatioPresets: [
                          CropAspectRatioPreset.square
                        ],
                            uiSettings: [
                              AndroidUiSettings(
                                toolbarTitle: 'Cropper',
                                toolbarColor: color,
                                toolbarWidgetColor:Colors.white,
                                initAspectRatio: CropAspectRatioPreset.original,
                                lockAspectRatio: false,

                              ),
                            ]);
                        if (croppedFile != null){
                          setState(() {
                            context.read<UpdateUserInfoBloc>().add(
                                UploadPicture(
                                    croppedFile.path,
                                    context.read<MyUserBloc>().state.user!.id));
                          });
                        }
                      }
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          image: DecorationImage(image: NetworkImage(state.user!
                              .picture!),
                              fit: BoxFit.cover)
                      ),),
                  ),

                  const SizedBox(width: 14,),
                  Text("Welcome ${state.user!.name}")
                ],
                );
              }
              else{
              return Container();
            }
          },
            ),
            actions: [
              IconButton(
                  onPressed: (){
                    context.read<SignBloc>().add(const SignOutRequired());
                  }, icon: const Icon(Icons.logout),color: Colors.orange,)
            ],
      ),
          body: BlocBuilder<GetPostBloc, GetPostState>(
            builder: (context, state) {
              if (state is GetPostSuccess) {
                return ListView.builder(
                    itemCount: state.posts.length,
                    itemBuilder: (context, int i) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: double.infinity,
                          //height: 400,
                          //color: Colors.orange,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          shape: BoxShape.circle,
                                          image: DecorationImage(image: NetworkImage(state.posts[i].myUser.picture!),
                                              fit: BoxFit.cover)
                                      ),),
                                    const SizedBox(width: 14,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        Text(
                                          state.posts[i].myUser.name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18

                                          ),),
                                        const SizedBox(height: 7,),
                                        Text(
                                          DateFormat('yyyy-MM-dd').format(state.posts[i].createdAt)

                                        )
                                      ],
                                    )
                                  ],

                                ),
                                const SizedBox(height: 14,),
                                Container(
                                  //color: Colors.amber,
                                  child: Text(
                                      state.posts[i].post,
                                     ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              }else if(state is GetPostLoading){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              else{
                return const Center(
                    child: Text("An Error Occurred ! "));
              }
  },
)
    ),
);
  }
}
