//
//  ViewController.swift
//  TheHillCipher
//
//  Created by Olteanu Andrei on 18/10/2018.
//  Copyright © 2018 Andrei Olteanu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class MainViewController: UIViewController, StoryboardBased {

    // MARK: - Outlets

    @IBOutlet weak var plaintextTextField: UITextField!
    @IBOutlet weak var encryptionKeyTextField: UITextField!
    @IBOutlet weak var encryptionMatrixTextField: UITextField!
    @IBOutlet weak var encryptButton: RoundedAppleButton!
    @IBOutlet weak var decryptButton: RoundedAppleButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    // MARK: - Private Properties

    private let service = HillCipherServiceImpl()

    private let isLoadingSubject = PublishSubject<Bool>()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupBindings()
    }

    // MARK: - Private Methods

    private func setupView() {
        navigationItem.title = "Hill Cipher"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "History", style: .plain, target: self, action: #selector(rightBarButtonTouched))

        spinner.hidesWhenStopped = true
        encryptButton.setEnabled(false)
        decryptButton.setEnabled(false)
    }

    private func setupBindings() {

        isLoadingSubject
            .bind { [weak self] isLoading in
                if isLoading {
                    self?.spinner.isHidden = false
                    self?.spinner.startAnimating()
                } else {
                    self?.spinner.stopAnimating()
                }
            }
            .disposed(by: disposeBag)

        Observable
            .combineLatest(plaintextTextField.rx.text, encryptionMatrixTextField.rx.text)
            .map { ($0.0 ?? "").isAlphabetic && ($0.1 ?? "").isValidForMatrixEntry }
            .bind { [weak self] isEnabled in
                self?.encryptButton.setEnabled(isEnabled)
            }
            .disposed(by: disposeBag)

        Observable
            .combineLatest(encryptionKeyTextField.rx.text, encryptionMatrixTextField.rx.text)
            .map { ($0.0 ?? "").isAlphabetic && ($0.1 ?? "").isValidForMatrixEntry }
            .bind { [weak self] isEnabled in
                self?.decryptButton.setEnabled(isEnabled)
            }
            .disposed(by: disposeBag)
    }

    private func save(_ historyItem: History) {
        let userDefaultsManager = UserDefaultsManager.shared
        var newHistory = userDefaultsManager.history
        newHistory.append(historyItem)
        userDefaultsManager.history = newHistory
    }

    @objc private func rightBarButtonTouched() {
        let viewController = HistoryViewController.instantiate()
        viewController.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }

    // MARK: - Actions

    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }

    @IBAction func encryptButtonTouched(_ sender: Any) {
        guard let encryptionMatrixText = encryptionMatrixTextField.text else { return }
        guard let plaintext = plaintextTextField.text else { return }

        DispatchQueue.main.async {
            self.isLoadingSubject.onNext(true)

            self.service.encryptionMatrix = encryptionMatrixText.formatForMatrix()
            self.service.plainText = plaintext.lowercased()

            do {
                try self.service.encrypt(completion: { key in
                    self.encryptionKeyTextField.text = key
                    self.isLoadingSubject.onNext(false)
                    self.decryptButton.setEnabled(true)

                    self.save(History(type: .encryption, plaintext: plaintext, encryptionKey: key, encryptionMatrix: encryptionMatrixText))
                })
            } catch {
                guard let error = error as? MatrixError else { return }
                self.isLoadingSubject.onNext(false)
                self.showAlert(with: error.localizedDescription)
            }
        }
    }
    
    @IBAction func decryptButtonTouched(_ sender: Any) {
        guard let encryptionMatrixText = encryptionMatrixTextField.text else { return }
        guard let encryptionKey = encryptionKeyTextField.text else { return }

        DispatchQueue.main.async {
            self.isLoadingSubject.onNext(true)

            self.service.encryptionMatrix = encryptionMatrixText.formatForMatrix()
            self.service.encryptionKey = encryptionKey.lowercased()

            do {
                try self.service.decrypt(completion: { plaintext in
                    self.plaintextTextField.text = plaintext
                    self.isLoadingSubject.onNext(false)
                    self.encryptButton.setEnabled(true)

                    self.save(History(type: .decryption, plaintext: plaintext, encryptionKey: encryptionKey, encryptionMatrix: encryptionMatrixText))
                })
            } catch {
                guard let error = error as? MatrixError else { return }
                self.isLoadingSubject.onNext(false)
                self.showAlert(with: error.localizedDescription)
            }
        }
    }
}

// MARK: - HistoryViewControllerDelegate

extension MainViewController: HistoryViewControllerDelegate {
    func didSelectHistoryItem(_ historyItem: History) {
        plaintextTextField.text = historyItem.plaintext
        encryptionKeyTextField.text = historyItem.encryptionKey
        encryptionMatrixTextField.text = historyItem.encryptionMatrix

        encryptButton.setEnabled(true)
        decryptButton.setEnabled(true)
    }
}
