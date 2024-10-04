//
//  AddTaskListTableViewController.swift
//  Remind Me
//
//  Created by huy.dang on 9/27/24.
//

import UIKit

protocol AddTaskListTableViewControllerDelegate: AnyObject {
    func addTaskListSuccessHandle(list: TaskList)
    func editTaskListSuccessHandle(list: TaskList)
}

class AddTaskListTableViewController: UITableViewController {
    
    private let vm: AddTaskListViewModel = AddTaskListViewModel()
    private let colors: [String] = ["#D22B2B", "#F28C28", "#FDDA0D", "#55847A", "#4169E1", "#CF9FFF", "#6F4E37"]
    private var colorChoosen: String = ""
    weak var delegate: AddTaskListTableViewControllerDelegate?
    var taskList: TaskList?

    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var colorsCollectionView: UICollectionView!
    @IBOutlet weak var listIconImageView: UIImageView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var listNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = taskList != nil ? "Detail" : "New List"
        cancelButton.setupPlainLightTitleButton()
        doneButton.setupPlainBoldTitleButton()
        listNameTextField.becomeFirstResponder()
        let nib = UINib(nibName: "TaskListChooseColorCollectionViewCell", bundle: .main)
        colorsCollectionView.register(nib, forCellWithReuseIdentifier: "colorCell")
        colorsCollectionView.delegate = self
        colorsCollectionView.dataSource = self
        vm.delegate = self
        colorsCollectionView.isScrollEnabled = false
        if let taskList = self.taskList {
            listNameTextField.text = taskList.name
            colorChoosen = taskList.tintColor
            for i in 0..<colors.count {
                if taskList.tintColor == colors[i] {
                    colorsCollectionView.selectItem(at: IndexPath(row: i, section: 0), animated: false, scrollPosition: [])
                    break
                }
            }
        } else {
            colorChoosen = colors[3]
            colorsCollectionView.selectItem(at: IndexPath(row: 3, section: 0), animated: false, scrollPosition: [])
        }
        listIconImageView.tintColor = UIColor().colorFrom(hex: colorChoosen)
        doneButton.isEnabled = listNameTextField.text != "" ? true : false
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        if listNameTextField.text != "" {
            view.endEditing(true)
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Discard Changes", style: .destructive, handler: { _ in
                self.dismiss(animated: true)
            }))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            actionSheet.view.tintColor = .greyscale800
            present(actionSheet, animated: true)
        } else {
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        vm.name = listNameTextField.text!
        vm.tintColor = colorChoosen
        if self.taskList != nil {
            taskList?.name = listNameTextField.text!
            taskList?.tintColor = colorChoosen
            vm.editTaskList(list: taskList!)
        } else {
            vm.addNewTaskList()
        }
    }
    
    @IBAction func listNameTextFieldChange(_ sender: Any) {
        doneButton.isEnabled = listNameTextField.text?.isEmptyString() == true ? false : true
    }
}

extension AddTaskListTableViewController: UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, AddTaskListViewModelDelegate {
    
    func editTaskListSuccessHandle(list: TaskList) {
        self.dismiss(animated: true)
        delegate?.editTaskListSuccessHandle(list: list)
    }
    
    func addTaskListSuccessHandle(list: TaskList) {
        self.dismiss(animated: true)
        delegate?.addTaskListSuccessHandle(list: list)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colorsCollectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as! TaskListChooseColorCollectionViewCell
        cell.hexColor = colors[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        listIconImageView.tintColor = UIColor().colorFrom(hex: colors[indexPath.row])
        colorChoosen = colors[indexPath.row]
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}
