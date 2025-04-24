import 'package:flutter/material.dart';

class CouponsScreen extends StatelessWidget {
  const CouponsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the coupon data
    final List<Map<String, dynamic>> coupons = [
      {
        'title': 'Descuento en McNuggets',
        'description': 'Disfruta de un descuento en McNuggets',
        'price': '\$59',
        'imageUrl': 'https://mcd-landings-l-statics.appmcdonalds.com/uploads-live/Mc_Nugg_Pap_Gd_89c8c24eeb.png',
        'level': 'Cono',
        'points': '100',
        'isDisabled': false,
      },
      {
        'title': 'Sundae Chocolate + Sundae de Fresa',
        'description': 'Disfruta de un descuento en McNuggets',        
        'price': '\$39',
        'imageUrl': 'https://mcd-landings-l-statics.appmcdonalds.com/uploads-live/sundaes_6281cb4a7d.png',
        'level': 'Cono',
        'points': '100',
        'isDisabled': false,
      },
      {
        'title': '2 Papas Medianas',
        'description': 'Disfruta de un descuento en McNuggets',
        'price': '\$39',
        'imageUrl': 'https://mcd-landings-l-statics.appmcdonalds.com/uploads-live/2_Papas_Med_df72746664.png',
        'level': 'Oro',
        'points': '50',
        'isDisabled': false,
      },
      {
        'title': 'Big Mac + Papas Medianas',
        'description': 'Disfruta de un descuento en McNuggets',
        'price': '\$79',
        'imageUrl': 'https://mcd-landings-l-statics.appmcdonalds.com/uploads-live/Big_Mac_Papas_Med_10f9adc616.png',
        'level': 'Cono',
        'points': '75',
        'isDisabled': false,
      },
      {
        'title': '2 Big Mac + 2 Refrescos Medianos',
        'description': 'Disfruta de un descuento en McNuggets',
        'price': '\$99',
        'imageUrl': 'https://mcd-landings-l-statics.appmcdonalds.com/uploads-live/2_Big_Mac2_Ref_Med_75c0b94f37.png',
        'level': 'Sundae',
        'points': '460',
        'isDisabled': true,
      },
      {
        'title': 'McTrío Mediano Big Mac + McTrío Mediano Cuarto de Libra',
        'description': 'Disfruta de un descuento en McNuggets',
        'price': '\$99',
        'imageUrl': 'https://mcd-landings-l-statics.appmcdonalds.com/uploads-live/Mc_Trio_Big_Mac_Mc_Trio_Cuartode_Libra_Med_e835e5d0a2.png',
        'level': 'McFlurry',
        'points': '500',
        'isDisabled': true,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cupones'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Cupones Disponibles',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: coupons.length,
              itemBuilder: (context, index) {
                return _CouponCard(
                  title: coupons[index]['title'],
                  description: coupons[index]['description'],                  
                  price: coupons[index]['price'],
                  imageUrl: coupons[index]['imageUrl'],
                  level: coupons[index]['level'],
                  points: coupons[index]['points'],
                  isDisabled: coupons[index]['isDisabled'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CouponCard extends StatelessWidget {
  final String title;
  final String description;
  final String price;
  final String imageUrl;
  final String level;
  final String points;
  final bool isDisabled; // Indicates if the coupon is disabled

  const _CouponCard({
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.level,
    required this.points,

    this.isDisabled = false, // Default to false
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: ColorFiltered(
                  colorFilter: isDisabled
                      ? const ColorFilter.mode(
                          Colors.grey,
                          BlendMode.saturation,
                        )
                      : const ColorFilter.mode(
                          Colors.transparent,
                          BlendMode.multiply,
                        ),
                  child: Image.network(
                    imageUrl,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 150,
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey[400],
                          size: 50,
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis
                          ),
                        )),
                       
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isDisabled ? Colors.grey : Colors.orange,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            price,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isDisabled
                            ? null // Disable the button if the coupon is disabled
                            : () {
                                // TODO: Implement coupon claim functionality
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isDisabled ? Colors.grey : Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          isDisabled
                              ? 'Cupón no disponible'
                              : 'Reclamar Cupón',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (isDisabled)
          Positioned(
          top: 8,
          right: 8,
          child: Column(
            children: [  
              Row(
                children: [
                  Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                      Icons.lock,
                      color: Colors.white,
                      size: 24,
                    ),
                      Text(
                    level,
                    style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                        ),
                  ),
                    ],
                  )
                ),
                ],
              ),          
             Row(
              
              children: [
                 Container(
                  margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                 
                  Text(
                'McPuntos: $points',
                style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                    ),
              ),
                ],
              )
            ),
              ],
             )
            
            ],
          ),
        ),
      ],
    );
  }
}
