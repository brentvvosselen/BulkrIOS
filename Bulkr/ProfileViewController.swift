import UIKit

class ProfileViewController: UIViewController{
    @IBOutlet weak var postsTableView: UITableView!
    
    var posts: [Post] = []
    
    override func viewDidLoad() {
        PostService.getMyProjects(completion: {(response) -> Void in
            self.setPosts(response)
            print("after set")
            self.postsTableView.dataSource = self
            self.postsTableView.reloadData()
        })
        print("before datasource")
        
        
    }
    
    func setPosts(_ posts: [Post]){
        self.posts = posts
        print(posts[0].poster!.email)
        
    }
}

extension ProfileViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostCell
        cell.post = posts[indexPath.row]
        return cell
    }
    
    
}
