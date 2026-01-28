Main UI Implementation (main dart) : 

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final PostRepository repository = PostRepository();
  late Future<List<Post>> postList;

  @override
  void initState() {
    super.initState();
    postList = repository.fetchPosts(); // Initializing the fetch [00:24:51]
  }

  // Method to trigger the POST request [00:26:29]
  void sendPost() async {
    try {
      Post newPost = Post(userId: 1, title: "Hello Flutter", body: "This is a test post");
      Post createdPost = await repository.createPost(newPost);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Success: Created Post ID ${createdPost.id}"))
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error creating post"))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flutter GET & POST")),
      body: FutureBuilder<List<Post>>(
        future: postList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // [00:25:35]
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final post = snapshot.data![index];
                return ListTile(
                  title: Text(post.title),
                  subtitle: Text(post.body),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: sendPost,
        child: Icon(Icons.add),
      ),
    );
  }
}
