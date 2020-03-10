import UIKit

final class TranslationViewController: UIViewController {

    @IBOutlet private weak var beforeTranslationTextView: UITextView!
    @IBOutlet private weak var afterTranslationTextView: UITextView!

    private let hiraganaTranslatorModel: HiraganaTranslatorModel
    private var isFirst = false

    init(hiraganaTranslatorModel: HiraganaTranslatorModel) {
        self.hiraganaTranslatorModel = hiraganaTranslatorModel
        super.init(nibName: AppConst.translationViewController, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        beforeTranslationTextView.delegate = self
        hiraganaTranslatorModel.delegate = self
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    private func setupNavBar() {
        self.title = AppConst.hiraganaTranslation
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removeText(_:)))
        navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9078665376, green: 0.487560451, blue: 0.2430685163, alpha: 1)
    }

    @objc private func removeText(_ sender: UIBarButtonItem) {
        beforeTranslationTextView.text = ""
        afterTranslationTextView.text = ""
    }
}

extension TranslationViewController: UITextViewDelegate {

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if !isFirst {
            beforeTranslationTextView.text = ""
        }
        isFirst = true
        return true
    }

    func textViewDidChange(_ textView: UITextView) {
        hiraganaTranslatorModel.fetchHiragana(withSentence: textView.text)
    }
}

extension TranslationViewController: HiraganaTranslatorDelegate {
    func hiraganaTranslatorModel(_ hiraganaTranslatorModel: HiraganaTranslatorModel, didRecieve errorMessage: ErrorMessage) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: errorMessage.title, message: errorMessage.message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: false, completion: nil)
        }
    }

    func hiraganaTranslatorModel(_ hiraganaTranslatorModel: HiraganaTranslatorModel, didChange hiraganaText: String) {
        DispatchQueue.main.async {
            self.afterTranslationTextView.text = hiraganaText
        }
    }
}
