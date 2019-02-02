//
//  YearDataCell.swift
//  sphData
//
//  Created by Michael Schembri on 2/2/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit

class YearDataCell: UITableViewCell {
	
	var yearLabel: UILabel = {
		let label = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 50)))
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = Theme.current.defaultTextColor
		label.font = Theme.current.titleFont
		return label
	}()
	
	var downloadsLabel: UILabel = {
		let label = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 50)))
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = Theme.current.subTitleFont
		return label
	}()
	
	var iconImageView: UIImageView = {
		let logoView = UIImageView()
		logoView.image = #imageLiteral(resourceName: "chart-down").withRenderingMode(.alwaysTemplate).tinted(with: Theme.current.redTextColor)
		logoView.contentMode = .scaleAspectFit
		logoView.isHidden = true
		logoView.translatesAutoresizingMaskIntoConstraints = false
		return logoView
	}()
	
	private static func stackSection() -> UIStackView {
		let sv = UIStackView()
		sv.axis = .vertical
		sv.distribution = .equalCentering
		sv.translatesAutoresizingMaskIntoConstraints = false
		return sv
	}
	
	private static func stack() -> UIStackView {
		let sv = UIStackView()
		sv.axis = .horizontal
		sv.distribution = .fill
		sv.alignment = .center
		sv.translatesAutoresizingMaskIntoConstraints = false
		return sv
	}
	
	static let cellID = "yearCell"
	private let leftStack = YearDataCell.stackSection()
	private let rightStack = YearDataCell.stackSection()
	private let stack = YearDataCell.stack()
	
	var data: YearRecord! {
		didSet {
			yearLabel.text = data.year
			let trimmedDouble = String(format: "%.4f", data.totalData)
			downloadsLabel.text = "\(trimmedDouble) pb"
			applyCellStyling(data.allQuartersDidGrow)
		}
	}
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupView()
	}
	
	private func setupView() {
		leftStack.addArrangedSubview(yearLabel)
		leftStack.addArrangedSubview(downloadsLabel)
		rightStack.addArrangedSubview(iconImageView)
		let internalStackPadding: CGFloat = 8
		leftStack.spacing = internalStackPadding
		stack.addArrangedSubview(leftStack)
		stack.addArrangedSubview(rightStack)
		addSubview(stack)
		setupLayout()
	}
	
	private func setupLayout() {
		let imageSize: CGFloat = 50
		let margin: CGFloat = 20

		NSLayoutConstraint.activate([
			rightStack.widthAnchor.constraint(equalToConstant: imageSize),
			rightStack.heightAnchor.constraint(equalToConstant: imageSize),
			stack.topAnchor.constraint(equalTo: topAnchor),
			stack.bottomAnchor.constraint(equalTo: bottomAnchor),
			stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin),
			stack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -margin)
			])
	}
	
	func applyCellStyling(_ downloadsIncreased: Bool) {
		if downloadsIncreased {
			downloadsLabel.textColor = Theme.current.defaultTextColor
			iconImageView.isHidden = true
		} else {
			downloadsLabel.textColor = Theme.current.redTextColor
			iconImageView.isHidden = false
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("coder not implemented")
	}
}

