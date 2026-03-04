import 'package:flutter/material.dart';
import '../models/cat.dart';

class CatCard extends StatelessWidget {
  final Cat cat;
  final VoidCallback? onTap;

  const CatCard({
    super.key,
    required this.cat,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: cat.isSelected
              ? const Color(0xFF5B7DB8)
              : const Color(0xFF9E9E9E),
          borderRadius: BorderRadius.circular(16),
          border: cat.isSelected
              ? Border.all(color: const Color(0xFF3B5998), width: 3)
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _buildCatImage(),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cat.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${cat.ageYears} anos',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCatImage() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: cat.isSelected
                ? Border.all(color: const Color(0xFF3B5998), width: 2)
                : null,
            color: Colors.black,
          ),
          clipBehavior: Clip.antiAlias,
          child: _buildImageContent(),
        ),
        if (cat.isSelected)
          Positioned(
            top: -4,
            left: -4,
            child: Container(
              width: 22,
              height: 22,
              decoration: const BoxDecoration(
                color: Color(0xFF3B5998),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  'C',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildImageContent() {
    if (cat.imageUrl == null) {
      return _buildPlaceholder();
    }
    return Image.asset(
      cat.imageUrl!,
      fit: BoxFit.cover,
      width: 80,
      height: 80,
      errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    return const Center(
      child: Icon(
        Icons.image_rounded,
        size: 40,
        color: Colors.white,
      ),
    );
  }
}
