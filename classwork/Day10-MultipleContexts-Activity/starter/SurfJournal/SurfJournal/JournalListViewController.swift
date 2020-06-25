/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import CoreData

class JournalListViewController: UITableViewController {

  // MARK: Properties
  var coreDataStack: CoreDataStack!
  var fetchedResultsController: NSFetchedResultsController<JournalEntry> = NSFetchedResultsController()

  // MARK: IBOutlets
  @IBOutlet weak var exportButton: UIBarButtonItem!

  // MARK: View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    configureView()
  }

  // MARK: Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // 1
    if segue.identifier == "SegueListToDetail" {
      // 2
      guard let navigationController = segue.destination as? UINavigationController,
        let detailViewController = navigationController.topViewController as? JournalEntryViewController,
        let indexPath = tableView.indexPathForSelectedRow else {
          fatalError("Application storyboard mis-configuration")
      }
      // 3
      let surfJournalEntry = fetchedResultsController.object(at: indexPath)
      // 4
      detailViewController.journalEntry = surfJournalEntry
      detailViewController.context = surfJournalEntry.managedObjectContext
      detailViewController.delegate = self

    } else if segue.identifier == "SegueListToDetailAdd" {

      guard let navigationController = segue.destination as? UINavigationController,
        let detailViewController = navigationController.topViewController as? JournalEntryViewController else {
          fatalError("Application storyboard mis-configuration")
      }

      let newJournalEntry = JournalEntry(context: coreDataStack.mainContext)

      detailViewController.journalEntry = newJournalEntry
      detailViewController.context = newJournalEntry.managedObjectContext
      detailViewController.delegate = self
    }
  }
}

// MARK: IBActions
extension JournalListViewController {

  @IBAction func exportButtonTapped(_ sender: UIBarButtonItem) {
    exportCSVFile()
  }
}

// MARK: Private
private extension JournalListViewController {

  func configureView() {
    fetchedResultsController = journalListFetchedResultsController()
  }

  func exportCSVFile() { //save csv file to the disk
    navigationItem.leftBarButtonItem = activityIndicatorBarButtonItem()
/* //Replaced to work in background
    let context = coreDataStack.mainContext //dont use the main context for tasks you want to do in the background
    var results: [JournalEntry] = []
    do {
      results = try context.fetch(self.surfJournalFetchRequest())
    } catch let error as NSError {
      print("ERROR: \(error.localizedDescription)")
    }
*/
    
    // 1 First, retrieve all JournalEntry entities by executing a fetch request.
    coreDataStack.storeContainer.performBackgroundTask { context in //This creates a new managed object context and passes it into the closure. The context created by performBackgroundTask(_:) is on a private queue, which doesn’t block the main UI queue.
      var results: [JournalEntry] = []
      do {
        results = try context.fetch(self.surfJournalFetchRequest())
      } catch let error as NSError {
        print("ERROR: \(error.localizedDescription)")
      }
      
      // 2 Next, create the URL for the exported CSV file by appending the file name (“export.csv”) to the output of the NSTemporaryDirectory method.
      let exportFilePath = NSTemporaryDirectory() + "export.csv" //The path returned by NSTemporaryDirectory is a unique directory for temporary file storage. This a good place for files that can easily be generated again and don’t need to be backed up by iTunes or to iCloud.
      let exportFileURL = URL(fileURLWithPath: exportFilePath)
      FileManager.default.createFile(atPath: exportFilePath, contents: Data(), attributes: nil) //create the empty file where you’ll store the exported data.
      
      // 3 First, the app needs to create a file handler for writing, which is simply an object that handles the low-level disk operations necessary for writing data. To create a file handler for writing, use the FileHandle(forWritingTo:) initializer.
      let fileHandle: FileHandle?
      do {
        fileHandle = try FileHandle(forWritingTo: exportFileURL)
      } catch let error as NSError {
        print("ERROR: \(error.localizedDescription)")
        fileHandle = nil
      }
      
      if let fileHandle = fileHandle {
        // 4 for each fetched journal entry, attempt to create a UTF8-encoded string using csv() on JournalEntry and data(using:allowLossyConversion:) on String.
        //If it’s successful, you write the UTF8 string to disk using the file handler write() method.
        for journalEntry in results {
          fileHandle.seekToEndOfFile()
          guard let csvData = journalEntry
            .csv()
            .data(using: .utf8, allowLossyConversion: false) else {
              continue
          }
          
          fileHandle.write(csvData)
        }
        
        // 5 //close file and show alert
        fileHandle.closeFile()
/* //Replaced to work in background
        print("Export Path: \(exportFilePath)")
        self.navigationItem.leftBarButtonItem = self.exportBarButtonItem()
        self.showExportFinishedAlertView(exportFilePath)
        
      } else {
        self.navigationItem.leftBarButtonItem = self.exportBarButtonItem()
      }
*/
        print("Export Path: \(exportFilePath)")
        // 6 perform all operations related to the UI on the main queue, such as showing an alert view when the export operation is finished
        DispatchQueue.main.async {
          self.navigationItem.leftBarButtonItem =
            self.exportBarButtonItem()
          self.showExportFinishedAlertView(exportFilePath)
        }
      } else {
        DispatchQueue.main.async {
          self.navigationItem.leftBarButtonItem =
            self.exportBarButtonItem()
        }
      }
    } // 7 Closing brace for performBackgroundTask
  }

  // MARK: Export
  
  func activityIndicatorBarButtonItem() -> UIBarButtonItem {
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    let barButtonItem = UIBarButtonItem(customView: activityIndicator)
    activityIndicator.startAnimating()
    
    return barButtonItem
  }
  
  func exportBarButtonItem() -> UIBarButtonItem {
    return UIBarButtonItem(title: "Export", style: .plain, target: self, action: #selector(exportButtonTapped(_:)))
  }

  func showExportFinishedAlertView(_ exportPath: String) {
    let message = "The exported CSV file can be found at \(exportPath)"
    let alertController = UIAlertController(title: "Export Finished", message: message, preferredStyle: .alert)
    let dismissAction = UIAlertAction(title: "Dismiss", style: .default)
    alertController.addAction(dismissAction)

    present(alertController, animated: true)
  }
}

// MARK: NSFetchedResultsController
private extension JournalListViewController {

  func journalListFetchedResultsController() -> NSFetchedResultsController<JournalEntry> {
    let fetchedResultController = NSFetchedResultsController(fetchRequest: surfJournalFetchRequest(),
                                                             managedObjectContext: coreDataStack.mainContext,
                                                             sectionNameKeyPath: nil,
                                                             cacheName: nil)
    fetchedResultController.delegate = self

    do {
      try fetchedResultController.performFetch()
    } catch let error as NSError {
      fatalError("Error: \(error.localizedDescription)")
    }

    return fetchedResultController
  }

  func surfJournalFetchRequest() -> NSFetchRequest<JournalEntry> {
    let fetchRequest:NSFetchRequest<JournalEntry> = JournalEntry.fetchRequest()
    fetchRequest.fetchBatchSize = 20

    let sortDescriptor = NSSortDescriptor(key: #keyPath(JournalEntry.date), ascending: false)
    fetchRequest.sortDescriptors = [sortDescriptor]

    return fetchRequest
  }
}

// MARK: NSFetchedResultsControllerDelegate
extension JournalListViewController: NSFetchedResultsControllerDelegate {

  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.reloadData()
  }
}

// MARK: UITableViewDataSource
extension JournalListViewController {
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return fetchedResultsController.sections?.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return fetchedResultsController.sections?[section].numberOfObjects ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SurfEntryTableViewCell
    configureCell(cell, indexPath: indexPath)
    return cell
  }

  private func configureCell(_ cell: SurfEntryTableViewCell, indexPath: IndexPath) {
    let surfJournalEntry = fetchedResultsController.object(at: indexPath)
    cell.dateLabel.text = surfJournalEntry.stringForDate()

    guard let rating = surfJournalEntry.rating?.int32Value else { return }

    switch rating {
    case 1:
      cell.starOneFilledImageView.isHidden = false
      cell.starTwoFilledImageView.isHidden = true
      cell.starThreeFilledImageView.isHidden = true
      cell.starFourFilledImageView.isHidden = true
      cell.starFiveFilledImageView.isHidden = true
    case 2:
      cell.starOneFilledImageView.isHidden = false
      cell.starTwoFilledImageView.isHidden = false
      cell.starThreeFilledImageView.isHidden = true
      cell.starFourFilledImageView.isHidden = true
      cell.starFiveFilledImageView.isHidden = true
    case 3:
      cell.starOneFilledImageView.isHidden = false
      cell.starTwoFilledImageView.isHidden = false
      cell.starThreeFilledImageView.isHidden = false
      cell.starFourFilledImageView.isHidden = true
      cell.starFiveFilledImageView.isHidden = true
    case 4:
      cell.starOneFilledImageView.isHidden = false
      cell.starTwoFilledImageView.isHidden = false
      cell.starThreeFilledImageView.isHidden = false
      cell.starFourFilledImageView.isHidden = false
      cell.starFiveFilledImageView.isHidden = true
    case 5:
      cell.starOneFilledImageView.isHidden = false
      cell.starTwoFilledImageView.isHidden = false
      cell.starThreeFilledImageView.isHidden = false
      cell.starFourFilledImageView.isHidden = false
      cell.starFiveFilledImageView.isHidden = false
    default:
      cell.starOneFilledImageView.isHidden = true
      cell.starTwoFilledImageView.isHidden = true
      cell.starThreeFilledImageView.isHidden = true
      cell.starFourFilledImageView.isHidden = true
      cell.starFiveFilledImageView.isHidden = true
    }
  }

  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    guard case(.delete) = editingStyle else { return }

    let surfJournalEntry = fetchedResultsController.object(at: indexPath)
    coreDataStack.mainContext.delete(surfJournalEntry)
    coreDataStack.saveContext()
  }
}

// MARK: JournalEntryDelegate
extension JournalListViewController: JournalEntryDelegate {
  
  func didFinish(viewController: JournalEntryViewController, didSave: Bool) {

    guard didSave,
      let context = viewController.context,
      context.hasChanges else {
        dismiss(animated: true)
        return
    }

    context.perform {
      do {
        try context.save()
      } catch let error as NSError {
        fatalError("Error: \(error.localizedDescription)")
      }

      self.coreDataStack.saveContext()
    }

    dismiss(animated: true)
  }
}
